package PSR::Constants;
use strict;
use warnings;
use utf8;
use 5.010_001;

use parent qw(Exporter);
our @EXPORT;
our @CONSTANTS;

BEGIN {
    require constant;
    my @constants = qw(
        PSR_NODE_ALT
        PSR_NODE_ANYCHAR
        PSR_NODE_LINEHEAD
        PSR_NODE_LINETAIL
        PSR_NODE_STRHEAD
        PSR_NODE_STRTAIL
        PSR_NODE_COMPUNIT
        PSR_NODE_QUEST
        PSR_NODE_STAR
        PSR_NODE_PLUS
        PSR_NODE_QUEST_NG
        PSR_NODE_STAR_NG
        PSR_NODE_PLUS_NG
        PSR_NODE_CHAR
        PSR_NODE_CAPTURE
        PSR_NODE_GROUP
        PSR_NODE_CHARCLASS
        PSR_NODE_REPEAT
        PSR_NODE_RANGE
        PSR_NODE_QUOTE
    );
    my $i = 0;
    constant->import({
        map { $_ => $i++ }
        @constants
    });
    push @EXPORT, @constants;
};

1;

