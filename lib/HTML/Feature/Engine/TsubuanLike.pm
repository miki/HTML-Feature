package HTML::Feature::Engine::TsubuanLike;
use strict;
use warnings;
use base qw(HTML::Feature::Engine);
use HTML::TreeBuilder;
use HTML::Feature::Result;


sub run{
    my $self = shift;
    my $c = shift;
    my $html_ref = shift;
    $self->_tag_cleaning($c, $html_ref);
    return $self->_score($c, $html_ref);
} 

sub _tag_cleaning {
    my $self = shift;
    my $c = shift;
    my $html_ref = shift;
    return unless $html_ref && $$html_ref;
    # preprocessing
    $$html_ref =~ s{<!-.*?->}{}xmsg;
    $$html_ref =~ s{<script[^>]*>.*?<\/script>}{}xmgs;
    $$html_ref =~ s{&nbsp;}{ }xmg;
    $$html_ref =~ s{&quot;}{\'}xmg;
    $$html_ref =~ s{\r\n}{\n}xmg;
    $$html_ref =~ s{^\s*(.+)$}{$1}xmg;
    $$html_ref =~ s{^\t*(.+)$}{$1}xmg;
    # control code ( 0x00 - 0x1F, and 0x7F on ascii)
    for ( 0 .. 31 ) {
        my $control_code = '\x' . sprintf( "%x", $_ );
        $$html_ref =~ s{$control_code}{}xmg;
    }
    $$html_ref =~ s{\x7f}{}xmg;
}

sub _score {
    my $self = shift;
    my $c = shift;
    my $html_ref = shift;
    my $root     = HTML::TreeBuilder->new_from_content($$html_ref);
    my $result   = HTML::Feature::Result->new;
    
    if (my $title = $root->find("title")) {
        $result->title($title->as_text);
    }

    if (my $desc = $root->look_down(
        _tag => 'meta',
        name => 'description'
    )) {
        my $string = $desc->attr('content');
        $string =~ s{<br>}{}xms;
        $result->desc($string);
    }

    my @tsubuan_score = grep {
        ($self->_tag_text_frac($_) > 0)
        && ($self->_tag_text_frac($_) < 0.1)
    } $root->descendants;
    
    my $target;
    if (@tsubuan_score) {
        @tsubuan_score = sort {
            length($b->as_text) <=> length($a->as_text)
        } @tsubuan_score;
        $self->{success} = 1;
        $target = $tsubuan_score[0];
    }
    else {
        $self->{success} = 0;
        $target = $root;
    }
    
    $result->text($target->as_text);
    $result->element($target);
    delete $self->{tag_text_frac};
    
    if ( $c->{enc_type} ) {
        map {
            Encode::encode( $c->{enc_type}, $result->$_ )
        } qw/title desc text/;
    }
    return $result;
}

sub _tag_text_frac {
    my ($self, $elem) = @_;
    
    unless ($self->{tag_text_frac}) {
        $self->{tag_text_frac} = {};
    }
    
    unless (defined($self->{tag_text_frac}->{$elem->idf})) {
        my $text = $elem->as_text;
        my @objs = $elem->descendants;
        
        $self->{tag_text_frac}->{$elem->idf} =
            (@objs * 2)
            / (length($text) + 1);
    }
    
    return $self->{tag_text_frac}->{$elem->idf};
}

1;


__END__

=head1 NAME

HTML::Feature::Engine::TsubuanLike

=head1 SYNOPSIS

    use HTML::Feature;
    use HTML::Feature::Engine::TsubuanLike;
    my $result = HTML::Feature->new()->parse($url);
    # this module is called on backend as custom engine

=head1 METHODS

=head2 new()

=head2 run()

=cut

