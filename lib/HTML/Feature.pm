package HTML::Feature;
use strict;
use warnings;
use vars qw($VERSION $UserAgent $engine @EXPORT_OK);
use Exporter qw(import);
use Carp;
use HTTP::Response::Encoding;
use Encode::Guess;
use List::Util qw(first);
use Scalar::Util qw(blessed);
use UNIVERSAL::require;
use URI;

$VERSION   = '2.00006';
@EXPORT_OK = qw(feature);

sub new {
    my $class = shift;
    my %arg   = @_;
    $class = ref $class || $class;
    my $self = bless \%arg, $class;
    $self->{enc_type} ||= 'utf8';

    return $self;
}

sub parse {
    my $self = shift;
    my $obj  = shift;

    if ( !$obj ) {
        croak('Usage: parse( $uri | $http_response | $html_ref )');
    }

    my $pkg = blessed($obj);
    if ( !$pkg ) {
        if ( my $ref = ref $obj ) {

            # if it's a scalar reference, then we've been passed a piece of
            # HTML code.
            if ( $ref eq 'SCALAR' ) {
                return $self->parse_html( $obj, @_ );
            }

            # Otherwise we don't know how to handle
            croak('Usage: parse( $uri | $http_response | $html_ref )');
        }

        # We seemed to have an unblessed scalar. Assume it's a URI
        $pkg = 'URI';
        $obj = URI->new($obj);
    }

    # If it's an object, then we can handle URI or HTTP::Response
    if ( $pkg->isa('URI') ) {
        return $self->parse_url( $obj, @_ );
    }
    elsif ( $pkg->isa('HTTP::Response') ) {
        return $self->parse_response( $obj, @_ );
    }
    else {
        croak('Usage: parse( $uri | $http_response | $html_ref )');
    }
}

sub parse_url {
    my $self = shift;
    my $url  = shift;
    my $ua   = $self->_user_agent();
    my $res  = $ua->get($url);
    $self->parse_response( $res, @_ );
}

sub parse_response {
    my $self = shift;
    my $res  = shift;
    $self->{base_url} = $res->base;
    my $content = $self->_decode_response($res);
    $self->_run( \$content, @_ );
}

sub parse_html {
    my $self     = shift;
    my $html     = shift;
    my $html_ref = ref $html ? $html : \$html;
    $self->_decode_htmlref($html_ref);
    $self->_run( $html_ref, @_ );
}

sub engine {
    my $self   = shift;
    my $engine = $self->{engine_obj};
    if ( !$engine ) {
        my $engine_module = $self->{engine} ? $self->{engine} : 'TagStructure';
        my $class = __PACKAGE__ . '::Engine::' . $engine_module;
        $class->require or die $@;
        $engine = $class->new;
        $self->{engine_obj} = $engine;
    }
    return $engine;
}

sub _run {
    my $self     = shift;
    my $html_ref = shift;
    my $opts     = shift || {};

    local $self->{element_flag} =
      exists $opts->{element_flag}
      ? $opts->{element_flag}
      : $self->{element_flag};
    $self->engine->run( $self, $html_ref );
}

sub _decode_response {
    my $self = shift;
    my $res  = shift;

    my @encoding = (
        $res->encoding,

        # XXX - falling back to latin-1 may be risky. See Data::Decode
        # could be multiple because HTTP response and META might be different
        ( $res->header('Content-Type') =~ /charset=([\w\-]+)/g ),
        "latin-1",
    );
    my $encoding = first { defined $_ && Encode::find_encoding($_) } @encoding;
    return Encode::decode( $encoding, $res->content );
}

sub _decode_htmlref {
    my $self     = shift;
    my $html_ref = shift;

    local $Encode::Guess::NoUTFAutoGuess = 1;
    my $guess =
      Encode::Guess::guess_encoding( $$html_ref,
        ( 'shiftjis', 'euc-jp', '7bit-jis', 'utf8' ) );
    unless ( ref $guess ) {
        $$html_ref = Encode::decode( "latin-1", $$html_ref );
    }
    else {
        eval { $$html_ref = $guess->decode($$html_ref); };
    }
}

sub _user_agent {
    my $self = shift;
    require LWP::UserAgent;
    $UserAgent ||= LWP::UserAgent->new();
    $self->{user_agent} and $UserAgent->agent( $self->{user_agent} );
    $self->{http_proxy} and $UserAgent->proxy( ['http'], $self->{http_proxy} );
    $self->{timeout}    and $UserAgent->timeout( $self->{timeout} );
    return $UserAgent;
}

sub feature {
    my $self   = __PACKAGE__->new;
    my $result = $self->parse(@_);
    my %ret    = (
        text    => $result->text,
        title   => $result->title,
        desc    => $result->desc,
        element => $result->element
    );
    return wantarray ? %ret : $ret{text};
}

sub extract {
    warn
"HTML::Feature::extract() has been deprecated. Use HTML::Feature::parse() instead";
    my $self   = shift;
    my %args   = @_;
    my $result = $self->parse( $args{string} ? \$args{string} : $args{url} );
    my $ret    = {
        title       => $result->title,
        description => $result->desc,
        block       => [ { contents => $result->text } ],
    };
    return $ret;
}

1;

__END__

=head1 NAME

HTML::Feature - Extract Feature Sentences From HTML Documents

=head1 SYNOPSIS

    use HTML::Feature;

    my $f = HTML::Feature->new(enc_type => 'utf8');
    my $result = $f->parse('http://www.perl.com');

    print "Title:"        , $result->title(), "\n";
    print "Description:"  , $result->desc(),  "\n";
    print "Featured Text:", $result->text(),  "\n";


    # you can get a HTML::Element object
 
    my $f = HTML::Feature->new();
    my $result = $f->parse('http://www.perl.com',{element_flag => 1});
    print "HTML Element:",  $result->element->as_HTML, "\n";
    $result->element_delete();


    # a simpler method is, 

    use HTML::Feature qw(feature);
    print scalar feature('http://www.perl.com');

    # very simple!


=head1 DESCRIPTION 

This module extracst blocks of feature sentences out of an HTML document. 

Unlike other modules that performs similar tasks, this module by default
extracts blocks without using morphological analysis, and instead it uses 
simple statistics processing. 

Because of this, HTML::Feature has an advantage over other similar modules 
in that it can be applied to documents in any language.

=head1 METHODS 

=head2 new()

    my $f = HTML::Feature->new(%param);
    my $f = HTML::Feature->new(
        engine => $class, # backend engine module (default: 'TagStructure') 
        max_bytes => 5000, # max number of bytes per node to analyze (default: '')
        min_bytes => 10, # minimum number of bytes per node to analyze (default is '')
        enc_type => 'euc-jp', # encoding of return values (default: 'utf-8')
        user_agent => 'my-agent-name', # LWP::UserAgent->agent (default: 'libwww-perl/#.##') 
        http_proxy => 'http://proxy:3128', # http proxy server (default: '')
        timeout => 10, # set the timeout value in seconds. (default: 180)
        element_flag => 1, # flag of HTML::Element object as returned value (default: '') 
   );

Instantiates a new HTML::Feature object. Takes the following parameters

=over 4

=item engine

Specifies the class name of the engine that you want to use.

HTML::Feature is designed to accept different engines to change its behavior.
If you want to customize the behavior of HTML::Feature, specify your own
engine in this parameter

=back 

The rest of the arguments are directly passed to the HTML::Feature::Engine 
object constructor.

=head2 parse()

    my $result = $f->parse($url);
    # or
    my $result = $f->parse($html_ref);
    # or
    my $result = $f->parse($http_response);

Parses the given argument. The argument can be either a URL, a string of HTML
(must be passed as a scalar reference), or an HTTP::Response object.
HTML::Feature will detect and delegate to the appropriate method (see below)

=head2 parse_url($url)

Parses an URL. This method will use LWP::UserAgent to fetch the given url.

=head2 parse_html($html)

Parses a string containing HTML.

=head2 parse_response($http_response)

Parses an HTTP::Response object.

=head2 extract()

    $data = $f->extract(url => $url);
    # or
    $data = $f->extract(string => $html);

HTML::Feature::extract() has been deprecated and exists for backwards compatiblity only. Use HTML::Feature::parse() instead.

extract() extracts blocks of feature sentences from the given document,
and returns a data structure like this:

    $data = {
        title => $title,
        description => $desc,
        block => [
            {
                contents => $contents,
                score => $score
            },
            .
            .
        ]
    }

=head2 feature

feature() is a simple wrapper that does new(), parse() in one step.
If you do not require complex operations, simply calling this will suffice.
In scalar context, it returns the feature text only. In list context,
some more meta data will be returned as a hash.

This function is exported on demand.

    use HTML::Feature qw(feature);
    print scalar feature($url);  # print featured text

    my %data = feature($url); # wantarray(hash)
    print $data{title};
    print $data{desc};
    print $data{text};


=head1 AUTHOR 

Takeshi Miki <miki@cpan.org> 

Special thanks to Daisuke Maki

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 Takeshi Miki This library is free software; you can redistribute it and/or modifyit under the same terms as Perl itself, either Perl version 5.8.8 or,at your option, any later version of Perl 5 you may have available.

=cut
