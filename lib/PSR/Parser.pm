package PSR::Parser;
use strict;
use warnings;
use utf8;
use 5.010_001;
use PSR::Node;
use PSR::Constants;

my $WHITESPACE = qr{\s*};

sub new { bless {}, shift }

sub parse {
    my ($self, $re) = @_;
    local $_ = $re;

    return _parse_compunit();
}

sub _parse_compunit {
    my @nodes;
    until (/\G$WHITESPACE\z/gc) {
        my $alt = _parse_alt();
        if ($alt) {
            push @nodes, $alt;
        } else {
            die "Syntax error at " . pos();
        }
    }
    return PSR::Node->new(PSR_NODE_COMPUNIT, \@nodes);
}

# alt = postfix "|" alt
#     | postfix
sub _parse_alt {
    my $lhs = _parse_postfix()
        or return undef;

    if (/\G$WHITESPACE\|/gc) {
        if (my $rhs = _parse_alt()) {
            return PSR::Node->new(PSR_NODE_ALT, [$lhs, $rhs]);
        } else {
            die "Unexpected token after '|' at " . pos();
        }
    } else {
        return $lhs;
    }
}

# postfix = term "?"
#         | term "*"
#         | term "+"
#         | term "??"
#         | term "*?"
#         | term "+?"
#         | term
sub _parse_postfix {
    my $term = _parse_term()
        or return undef;

    if (/\G$WHITESPACE\?\?/gc) {
        return PSR::Node->new(PSR_NODE_QUEST_NG, $term);
    } elsif (/\G$WHITESPACE\*\?/gc) {
        return PSR::Node->new(PSR_NODE_STAR_NG, $term);
    } elsif (/\G$WHITESPACE\+\?/gc) {
        return PSR::Node->new(PSR_NODE_PLUS_NG, $term);
    } elsif (/\G$WHITESPACE\?/gc) {
        return PSR::Node->new(PSR_NODE_QUEST, $term);
    } elsif (/\G$WHITESPACE\*\*$WHITESPACE([0-9]+)$WHITESPACE\.\.$WHITESPACE([0-9]+)/gc) {
        return PSR::Node->new(PSR_NODE_REPEAT, [$term, PSR::Node->new(PSR_NODE_RANGE, [$1, $2])]);
    } elsif (/\G$WHITESPACE\*\*$WHITESPACE([0-9]+)/gc) {
        return PSR::Node->new(PSR_NODE_REPEAT, [$term, $1]);
    } elsif (/\G$WHITESPACE([0-9]+)/gc) {
        return PSR::Node->new(PSR_NODE_REPEAT, $1);
    } elsif (/\G$WHITESPACE\*/gc) {
        return PSR::Node->new(PSR_NODE_STAR, $term);
    } elsif (/\G$WHITESPACE\+/gc) {
        return PSR::Node->new(PSR_NODE_PLUS, $term);
    } else {
        return $term;
    }
}

sub _parse_group {
    my $close = shift;

    my @nodes;
    until (/\G$WHITESPACE@{[ quotemeta($close) ]}/gc) {
        my $alt = _parse_alt();
        if ($alt) {
            push @nodes, $alt;
        } else {
            die "Syntax error at " . pos();
        }
    }
    return PSR::Node->new($close eq ')' ? PSR_NODE_CAPTURE : PSR_NODE_GROUP, \@nodes);
}

# term = "."
#      | "[" compunit "]"
#      | "(" compunit ")"
#      | "<[" charclass "]>"
#      | [^] # any char
sub _parse_term {
    /\G$WHITESPACE/gc;

    if (/\G\./gc) {
        return PSR::Node->new(PSR_NODE_ANYCHAR);
    } elsif (/\G\(/gc) {
        return _parse_group(')');
    } elsif (/\G\[/gc) {
        return _parse_group(']');
    } elsif (/\G'([^']+)'/gc) {
        return PSR::Node->new(PSR_NODE_QUOTE, "$1");
    } elsif (/\G"([^"]+)"/gc) {
        return PSR::Node->new(PSR_NODE_QUOTE, "$1");
    } elsif (/\G"/gc) {
    } elsif (/\G<\[(.*?)\]>/gc) {
        return PSR::Node->new(PSR_NODE_CHARCLASS, $1);
    } elsif (/\G\^\^/gc) {
        return PSR::Node->new(PSR_NODE_LINEHEAD);
    } elsif (/\G\^/gc) {
        return PSR::Node->new(PSR_NODE_STRHEAD);
    } elsif (/\G\$\$/gc) {
        return PSR::Node->new(PSR_NODE_LINETAIL);
    } elsif (/\G\$/gc) {
        return PSR::Node->new(PSR_NODE_STRTAIL);
    } elsif (/\G(.)/gc) {
        return PSR::Node->new(PSR_NODE_CHAR, $1);
    } else {
        die "SHOULD NOT REACH HERE: " . pos();
    }
}

1;

