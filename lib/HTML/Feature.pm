package HTML::Feature;
use strict;
use warnings;
use HTML::Feature::FrontParser;
use HTML::Feature::Engine;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(_front_parser _engine);

our $VERSION = '0.00001';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_setup;
    return $self;
}

sub parse {
    my $self      = shift;
    my $something = shift;
    my $url       = shift;
    my $html      = $self->front_parser->parse($something);
    if ( $self->{base_url} ) {
        $url = $self->{base_url};
    }
    my $result = $self->engine->run( \$html, $url );
    return $result;
}

sub parse_url {
    my $self = shift;
    $self->parse(@_);
}

sub parse_response {
    my $self = shift;
    $self->parse(@_);
}

sub parse_html {
    my $self = shift;
    $self->parse(@_);
}

sub _setup {
    my $self = shift;
    $self->front_parser( HTML::Feature::FrontParser->new( context => $self ) );
    $self->engine( HTML::Feature::Engine->new( context => $self ) );
    $self->{enc_type} = "utf8";
}

#---

sub front_parser {
    my $self = shift;
    my $args = shift;
    if ( !$args ) {
        $self->_front_parser;
    }
    else {
        $self->_front_parser($args);
    }
}

sub engine {
    my $self = shift;
    my $args = shift;
    if ( !$args ) {
        $self->_engine;
    }
    else {
        $self->_engine($args);
    }
}

1;
__END__

=head1 NAME

HTML::Feature -

=head1 SYNOPSIS

  use HTML::Feature;

  my $feature = HTML::Feature->new( 
      config => {
          engines => [
              'HTML::Feature::Engine::Hoge',
              'HTML::Feature::Engine::Fuga',
          ],
          not_decode => 1,
          not_encode => 1,
      }
  );

  my $result = $feature->parse($url);

  print $result->text;

=head1 DESCRIPTION

HTML::Feature is

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
