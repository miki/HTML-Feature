package HTML::Feature::FrontParser;
use strict;
use warnings;
use Carp;
use URI;
use Scalar::Util qw(blessed);
use UNIVERSAL::require;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw( _fetcher _decoder);

sub parse {
    my $self = shift;
    my $arg  = shift;
    if ( !$arg ) {
        croak('Usage: parse( $uri | $http_response | $html_ref )');
    }
    my $pkg = blessed($arg);
    if ( !$pkg ) {
        if ( my $ref = ref $arg ) {
            if ( $ref eq 'SCALAR' ) {
                my $html = $arg;
                unless ( $self->context->config->{not_decode} ) {
                    $html = $self->decoder->decode($html);
                }
                return $html;
            }
            croak('Usage: parse( $uri | $http_response | $html_ref )');
        }
        $pkg = 'URI';
        $arg = URI->new($arg);
    }
    if ( $pkg->isa('URI') ) {
        return $self->_parse_url( $arg, @_ );
    }
    elsif ( $pkg->isa('HTTP::Response') ) {
        return $self->_parse_response( $arg, @_ );
    }
    else {
        croak('Usage: parse( $uri | $http_response | $html_ref )');
    }
}

sub _parse_url {
    my $self = shift;
    my $url  = shift;
    my $res  = $self->fetcher->request($url);
    $self->_parse_response( $res, @_ );
}

sub _parse_response {
    my $self          = shift;
    my $http_response = shift;
    my $args          = shift;
    my $c             = $self->context;
    if ( $args->{element_flag} ) {
        $self->{element_flag} = $args->{element_flag};
    }
    $c->{base_url} = $http_response->base;
    my $html = $http_response->content;
    unless ( $self->context->config->{not_decode} ) {
        $html = $self->decoder->decode( $html, { response => $http_response } );
    }
    return $html;
}

#---

sub fetcher {
    my $self = shift;
    my $args = shift;
    if ( !$args ) {
        $self->_fetcher or sub {
            HTML::Feature::Fetcher->require or die $@;
            my $fetcher = HTML::Feature::Fetcher->new( context => $self );
            $self->_fetcher($fetcher);
          }
          ->();
    }
    else {
        $self->_fetcher($args);
    }
}

sub decoder {
    my $self = shift;
    my $args = shift;
    if ( !$args ) {
        $self->_decoder or sub {
            HTML::Feature::Decoder->require or die $@;
            $self->_decoder( HTML::Feature::Decoder->new( context => $self ) );
          }
          ->();
    }
    else {
        $self->_decoder($args);
    }
}

1;
