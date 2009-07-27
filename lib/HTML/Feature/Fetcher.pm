package HTML::Feature::Fetcher;
use strict;
use warnings;
use LWP::UserAgent;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(_user_agent);

sub fetch {
    my $self          = shift;
    my $url           = shift;
    my $http_response = $self->user_agent->get($url);
    return $http_response;
}

sub user_agent {
    my $self = shift;
    $self->_user_agent or sub {
        my $ua = LWP::UserAgent->new;
        my $c  = $self->context;
        $c->config->{user_agent} and $ua->agent( $c->config->{user_agent} );
        $c->config->{http_proxy} and $ua->proxy( ['http'], $c->config->{http_proxy} );
        $c->config->{timeout}    and $ua->timeout( $c->config->{timeout} );
        $self->_user_agent($ua);
      }
      ->();
}
1;
__END__

=head1 NAME

HTML::Feature::Fetcher -

=head1 SYNOPSIS

  use HTML::Feature::Fetcher;

=head1 DESCRIPTION

HTML::Feature::Fetcher is

=head1 METHODS

=head2 new

=head2 fetch

=head2 user_agent

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut