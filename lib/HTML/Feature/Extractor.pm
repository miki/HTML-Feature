package HTML::Feature::Extractor;
use strict;
use warnings;
use HTML::TreeBuilder;
use Statistics::Lite qw(statshash);
use HTML::Feature::Result;
use Data::Dumper;
use base qw(HTML::Feature::Base);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
}

sub extract {
    my $self     = shift;
    my $html_ref = shift;

    my $result =
         $self->_site_regexp($html_ref)
      || $self->_google_adsence($html_ref)
      || $self->_tag_structure($html_ref);
    return $result;
}

sub _site_regexp {
    my $self     = shift;
    my $html_ref = shift;
    my $c        = $self->context;
    my $url      = $c->{base_url};
    if ($url) {
        my %site_regexp = %{ $c->config->{site_regexp} };
        while ( my ( $site, $ref ) = each %site_regexp ) {
            Dumper $ref; # magic??
            if ( $url =~ /$site/ ) {
                my $root = HTML::TreeBuilder->new_from_content($$html_ref);
                $root->eof;
                my ( $regex_key, $regex_value ) = each %$ref;
                my $html = '<div>';
                if ( $regex_key and $regex_value ) {
                    for ( $root->look_down( $regex_key, qr/$regex_value/ ) ) {
                        $html .= $_->as_HTML;
                    }
                    $html .= '</div>';
                    return $self->_tag_structure( \$html );
                }
            }
        }
    }
    return 0;
}

sub _google_adsence {
    my $self     = shift;
    my $html_ref = shift;
    if ( $$html_ref =~
m|<!--\s+google_ad_section_start\s+-->(.+)<!--\s+google_ad_section_end\s+-->|os
      )
    {
        my $html = $1;
        return $self->_tag_structure( \$html );
    }
    return 0;
}

sub _tag_structure {
    my $self     = shift;
    my $html_ref = shift;
    my $c        = $self->context;

    $self->_tag_cleaning($html_ref);

    my $root   = HTML::TreeBuilder->new_from_content($$html_ref);
    my $result = HTML::Feature::Result->new;

    my $data;

    if ( my $title = $root->find("title") ) {
        $result->title( $title->as_text );
    }

    if ( my $desc = $root->look_down( _tag => 'meta', name => 'description' ) )
    {
        my $string = $desc->attr('content');
        $string =~ s{<br>}{}xms;
        $result->desc($string);
    }

    my $i = 0;
    my @ratio;
    my @depth;
    my @order;
    for my $node ( $root->look_down( "_tag", qr/body|center|td|div/i ) ) {
        my $html_length = bytes::length( $node->as_HTML );
        my $text        = $node->as_text;
        my $text_length = bytes::length($text);
        my $text_ration = $text_length / ( $html_length + 0.001 );

        next
          if (  $c->{max_bytes}
            and $c->{max_bytes} =~ /^[\d]+$/
            && $text_length > $c->{max_bytes} );
        next
          if (  $c->{min_bytes}
            and $c->{min_bytes} =~ /^[\d]+$/
            and $text_length < $c->{min_bytes} );

        my $a_count       = 0;
        my $a_length      = 0;
        my $option_count  = 0;
        my $option_length = 0;
        my %node_hash     = (
            text                => '',
            a_length            => 0,
            short_string_length => 0
        );

        $self->_walk_tree( $node, \%node_hash );

        $node_hash{a_length}            ||= 0;
        $node_hash{option_length}       ||= 0;
        $node_hash{short_string_length} ||= 0;
        $node_hash{text}                ||= $text;

        $data->[$i]->{text} = $node_hash{text};

        push(
            @ratio,
            (
                $text_length -
                  $node_hash{a_length} -
                  $node_hash{option_length} -
                  $node_hash{short_string_length}
              ) * $text_ration
        );
        push( @depth, $node->depth() );

        $data->[$i]->{element} = $node;

        $i++;
    }

    for ( 0 .. $i ) {
        push( @order, log( $i - $_ + 1 ) );
    }

    my %ratio = statshash @ratio;
    my %depth = statshash @depth;
    my %order = statshash @order;

    # avoid memory leak
    $root->delete() unless $c->{element_flag};

    my @sorted =
      sort { $data->[$b]->{score} <=> $data->[$a]->{score} }
      map {

        my $ratio_std =
          ( ( $ratio[$_] || 0 ) - ( $ratio{mean} || 0 ) ) /
          ( $ratio{stddev} + 0.001 );
        my $depth_std =
          ( ( $depth[$_] || 0 ) - ( $depth{mean} || 0 ) ) /
          ( $depth{stddev} + 0.001 );
        my $order_std =
          ( ( $order[$_] || 0 ) - ( $order{mean} || 0 ) ) /
          ( $order{stddev} + 0.001 );

        $data->[$_]->{score} = $ratio_std + $depth_std + $order_std;
        $_;
      } ( 0 .. $i );

    $data->[ $sorted[0] ]->{text}
      and $data->[ $sorted[0] ]->{text} =~ s/ $//s;

    $result->text( $data->[ $sorted[0] ]->{text} );

    if ( $c->{element_flag} ) {
        $result->root($root);
        $result->element( $data->[ $sorted[0] ]->{element} );
    }

    if ( $c->{enc_type} ) {
        $result->title( Encode::encode( $c->{enc_type}, $result->title ) );
        $result->desc( Encode::encode( $c->{enc_type}, $result->desc ) );
        $result->text( Encode::encode( $c->{enc_type}, $result->text ) );
    }

    return $result;
}

sub _walk_tree {
    my $self          = shift;
    my $node          = shift;
    my $node_hash_ref = shift;

    if ( ref $node ) {
        if ( $node->tag =~ /p|br|hr|tr|ul|li|ol|dl|dd|h[1-6]/ ) {
            $node_hash_ref->{text} .= "\n";
        }
        for (qw/a option dt th/) {
            if ( $node->tag eq $_ ) {
                $node_hash_ref->{a_length} += bytes::length( $node->as_text );
            }
        }
        if ( bytes::length( $node->as_text ) < 20 ) {
            $node_hash_ref->{short_string_length} +=
              bytes::length( $node->as_text );
        }
        $self->_walk_tree( $_, $node_hash_ref ) for $node->content_list();
    }
    else {
        $node_hash_ref->{text} .= $node . " ";
    }
}

sub _tag_cleaning {
    my $self     = shift;
    my $html_ref = shift;
    ## preprocessing
    $$html_ref =~ s{<!-.*?->}{}xmsg;
    $$html_ref =~ s{<script[^>]*>.*?<\/script>}{}xmgs;
    $$html_ref =~ s{&nbsp;}{ }xmg;
    $$html_ref =~ s{&quot;}{\'}xmg;
    $$html_ref =~ s{\r\n}{\n}xmg;
    $$html_ref =~ s{^\s*(.+)$}{$1}xmg;
    $$html_ref =~ s{^\t*(.+)$}{$1}xmg;
    ## control code ( 0x00 - 0x1F, and 0x7F on ascii)
    for ( 0 .. 31 ) {
        next if $_ == 10;    # without NL(New Line)
        my $control_code = '\x' . sprintf( "%x", $_ );
        $$html_ref =~ s{$control_code}{}xmg;
    }
    $$html_ref =~ s{\x7f}{}xmg;
}
1;
__END__

=head1 NAME

HTML::Feature::Extractor -

=head1 SYNOPSIS

  use HTML::Feature::Extractor;

=head1 DESCRIPTION

HTML::Feature::Extractor is

=head1 METHODS

=head2 new

=head2 extract

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut