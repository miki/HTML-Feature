package HTML::Feature::Decoder;
use strict;
use warnings;
use Data::Decode;
use Data::Decode::Chain;
use Data::Decode::Encode::HTTP::Response;
use Data::Decode::Encode::Guess;
use Data::Decode::Encode::Guess::JP;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(_decoder);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
}

sub decode {
    my $self    = shift;
    my $data    = shift;
    my $decoded = $self->decoder->decode($data);
    return $decoded;
}

sub decoder {
    my $self = shift;
    $self->_decoder or sub {
        my $decoder = Data::Decode->new(
            strategy => Data::Decode::Chain->new(
                decoders => [
                    Data::Decode::Encode::HTTP::Response->new,
                    Data::Decode::Encode::Guess->new,
                    Data::Decode::Encode::Guess::JP->new,
                ]
            )
        );
        $self->_decoder($decoder);
      }
      ->();
}
1;
__END__

=head1 NAME

HTML::Feature::Decoder -

=head1 SYNOPSIS

  use HTML::Feature::Decoder;

=head1 DESCRIPTION

HTML::Feature::Decoder is

=head1 METHODS

=head2 new

=head2 decode

=head2 decoder

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut