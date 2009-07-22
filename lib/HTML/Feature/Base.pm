package HTML::Feature::Base;
use strict;
use warnings;
use base qw(Class::Accessor::Fast Class::Data::ConfigHash);

__PACKAGE__->mk_accessors($_) for qw(context);

__PACKAGE__->config({ 
    site_regexp => { 
        qr/goo.ne.jp/ => { class => qr/^entry$|^etbody$/ },
        qr/hatena.ne.jp/ => { class => qr/^body$/ }
    },
        
});

sub new {
    my $class  = shift;
    my %args   = @_;
    my $config = delete $args{config};
    my $self   = $class->SUPER::new( {%args} );
    if ($config) {
        $self->config($config);
    }
    return $self;
}

1;
__END__

=head1 NAME

HTML::Feature::Base -

=head1 SYNOPSIS

  use HTML::Feature::Base;

=head1 DESCRIPTION

HTML::Feature::Base is

=head1 METHODS

=head2 new

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut