package HTML::Feature::Engine;
use strict;
use warnings;
#use base qw/Class::Accessor::Fast/;
#__PACKAGE__->mk_accessors(qw/text title desc element/);

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    return $self;
}

sub run { }

1;

__END__

=head1 NAME

HTML::Feature::Engine -Base Class For HTML::Feature Engine

=head1 SYNOPSIS

    package HTML::Feature::Engine::SomeEngine;
    use strict;
    use base qw(HTML::Feature::Engine);

    sub run {
        ....
    }

=head1 METHODS

=head2 new()

=head2 run()

    Starts the engine. The exact behavior differs between each engine

=cut
