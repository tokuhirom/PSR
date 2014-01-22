package PSR::Converter::Perl5;
use strict;
use warnings;
use utf8;
use 5.010_001;
use PSR::Constants;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub convert {
    my ($self, $node) = @_;
    return $self->_convert($node);
}

sub _convert {
    my ($self, $node) = @_;
    my $code = +{
        PSR_NODE_ANYCHAR() => sub { '.' },
        PSR_NODE_STRHEAD() => sub { '\A' },
        PSR_NODE_STRTAIL() => sub { '\z' },
        PSR_NODE_LINEHEAD() => sub { '^' },
        PSR_NODE_LINETAIL() => sub { '$' },
        PSR_NODE_QUEST() => sub { $self->_convert(shift->data) . '?' },
        PSR_NODE_STAR()  => sub { $self->_convert(shift->data) . '*' },
        PSR_NODE_PLUS()  => sub { $self->_convert(shift->data) . '+' },
        PSR_NODE_QUEST_NG() => sub { $self->_convert(shift->data) . '??' },
        PSR_NODE_STAR_NG()  => sub { $self->_convert(shift->data) . '*?' },
        PSR_NODE_PLUS_NG()  => sub { $self->_convert(shift->data) . '+?' },
        PSR_NODE_CHARCLASS() => sub {
            $self->_compile_charclass($_[0])
        },
        PSR_NODE_QUOTE() => sub {
            my $node = shift;
            "(?:" .  quotemeta($node->data) . ")";
        },
        PSR_NODE_REPEAT() => sub {
            my $node = shift;
            my @d = @{$node->data};
            my $v1 = $self->_convert($d[0]);
            my $v2 = do {
                if (ref $d[1]) {
                    $d[1]->data->[0] . ',' . $d[1]->data->[1];
                } else {
                    $d[1];
                }
            };
            sprintf("%s{%s}", $v1, $v2);
        },
        PSR_NODE_CAPTURE() => sub {
            my $node = shift;
            "(" .  $self->_convert($node->data->[0]) . ")";
        },
        PSR_NODE_GROUP() => sub {
            my $node = shift;
            "(?:" .  $self->_convert($node->data->[0]) . ")";
        },
        PSR_NODE_ALT() => sub {
            my $node = shift;
            $self->_convert($node->data->[0]) . '|' . $self->_convert($node->data->[1]);
        },
        PSR_NODE_CHAR() => sub {
            my $node = shift;
            quotemeta($node->data);
        },
        PSR_NODE_COMPUNIT() => sub {
            my $node = shift;
            my $re = join('', map { $self->_convert($_) } @{$node->data});
            return qr{$re}m;
        },
    }->{$node->type};
    unless ($code) {
        die "Unknown node type: " . $node->type_str;
    }
    my $ret = $code->($node);
    return $ret;
}

sub _compile_charclass {
    my ($self, $node) = @_;
    my $cc = $node->data;
    return "[${cc}]";
}

1;

