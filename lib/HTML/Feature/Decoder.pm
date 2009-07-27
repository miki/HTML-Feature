package HTML::Feature::Decoder;
use strict;
use warnings;
use Data::Decode qw(Encode::Guess Encode::Guess::JP Encode::HTTP::Response);
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(decoder);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_setup;
    return $self;
}

sub _setup {
    my $self    = shift;
    my $decoder = Data::Decode->new(
        decoder => [
            Data::Decode::Encode::HTTP::Response->new,
            Data::Decode::Encode::Guess::JP->new,
            Data::Decode::Encode::Guess->new,
        ]
    );
    $self->decoder($decoder);
}

sub decode {
    my $self    = shift;
    my $data    = shift;
    my $decoded = $self->decoder->decode($data);
    return $decoded;
}

1;
