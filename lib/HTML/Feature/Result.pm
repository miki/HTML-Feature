package HTML::Feature::Result;
use strict;
use warnings;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(text title desc element root);

sub element_delete {
    my $self = shift;
    if ( $self->root ) {
        $self->root->delete();
    }
}

sub DESTROY {
    my $self = shift;
    $self->element_delete();
}
1;