package HTML::Feature::Fetcher;
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(fetcher);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_setup;
    return $self;
}

sub _setup {
    my $self    = shift;
    my $fetcher = LWP::UserAgent->new;
    $self->fetcher($fetcher);
}

sub request {
    my $self     = shift;
    my $url      = shift;
    my $request  = HTTP::Request->new( GET => $url );
    my $response = $self->fetcher->request($request);
    return $response;
}

1;

