package HTML::Feature::Result;

use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/text title desc element root/);

sub new {
	my $class = shift;
	my $self = bless {@_}, $class;
	return $self;
}

sub element_delete {
	my $self = shift;
    if($self->root){
        $self->root->delete();
    }
}

sub DESTROY{
	my $self = shift;
    $self->element_delete();
}

1;

__END__

=head1 NAME

HTML::Feature::Result -Result Class of HTML::Feature

=head1 SYNOPSYS

    my $result = HTML::Feature::Result;
    $result->title("title");
    $result->desc("desc");
    $result->text("text");
    retrun $result;

=head1 METHODS

=head2 new()

=head2 element_delete()

    avoid memory leak;

=head2 DESTROY

=cut
