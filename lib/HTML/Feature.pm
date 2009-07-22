package HTML::Feature;
use strict;
use warnings;
use Exporter qw(import);
use Carp;
use Scalar::Util qw(blessed);
use URI;
use HTML::Feature::Fetcher;
use HTML::Feature::Decoder;
use HTML::Feature::Extractor;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(fetcher decoder extractor);

our @EXPORT_OK = qw(feature);
our $VERSION   = '3.00001_01';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_setup;
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
            if ( $ref eq 'SCALAR' ) {
                return $self->parse_html( $obj, @_ );
            }
            croak('Usage: parse( $uri | $http_response | $html_ref )');
        }
        $pkg = 'URI';
        $obj = URI->new($obj);
    }
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
    my $self          = shift;
    my $url           = shift;
    my $http_response = $self->fetcher->fetch($url);
    $self->parse_response( $http_response, @_ );
}

sub parse_response {
    my $self          = shift;
    my $http_response = shift;
    my $args          = shift;
    if ( $args->{element_flag} ) {
        $self->{element_flag} = $args->{element_flag};
    }
    $self->{base_url} = $http_response->base;
    my $html = $http_response->content;
    unless ( $self->config->{not_decode} ) {
        $html = $self->decoder->decode( $html, { response => $http_response } );
    }
    $self->extractor->extract( \$html );
}

sub parse_html {
    my $self     = shift;
    my $html_ref = shift;
    my $args     = shift;
    if ( $args->{url} ) {
        $self->{base_url} = $args->{url};
    }
    if ( $args->{element_flag} ) {
        $self->{element_flag} = $args->{element_flag};
    }
    my $html = $$html_ref;
    unless ( $self->config->{not_decode} ) {
        $html = $self->decoder->decode($html);
    }
    $self->extractor->extract( \$html );
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

sub _setup {
    my $self = shift;
    $self->{enc_type} ||= 'utf8';
    $self->fetcher( HTML::Feature::Fetcher->new( context => $self ) );
    $self->decoder( HTML::Feature::Decoder->new( context => $self ) );
    $self->extractor( HTML::Feature::Extractor->new( context => $self ) );
}

1;
__END__

=head1 NAME

HTML::Feature -

=head1 SYNOPSIS

  use HTML::Feature;

=head1 DESCRIPTION

HTML::Feature is

=head1 METHODS

=head2 new

=head2 parse

=head2 parse_url

=head2 parse_response 

=head2 parse_html

=head2 feature

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
