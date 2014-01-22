use strict;
use warnings;
use utf8;
use Test::More;

use PSR::Parser;
use JKML;

for (@{decode_jkml(join '', <DATA>)}) {
    my $parser = PSR::Parser->new();
    my $node = $parser->parse($_->[0]);
    is $node->as_sexp, $_->[1], $_->[0];
}

done_testing;

__DATA__
[
    [
        '^ a',
        '(compunit (strhead) (char a))'
    ],
    [
        '^^ a',
        '(compunit (linehead) (char a))'
    ],
    [
        'a$',
        '(compunit (char a) (strtail))'
    ],
    [
        'a$$',
        '(compunit (char a) (linetail))'
    ],
    [
        '.',
        '(compunit (anychar))'
    ],
    [
        'a|b',
        '(compunit (alt (char a) (char b)))'
    ],
    [
        'a|b|c',
        '(compunit (alt (char a) (alt (char b) (char c))))'
    ],
    [
        'a?',
        '(compunit (quest (char a)))'
    ],
    [
        'a+',
        '(compunit (plus (char a)))'
    ],
    [
        'a*',
        '(compunit (star (char a)))'
    ],
    [
        'a??',
        '(compunit (quest_ng (char a)))'
    ],
    [
        'a+?',
        '(compunit (plus_ng (char a)))'
    ],
    [
        'a*?',
        '(compunit (star_ng (char a)))'
    ],
    [
        '(a)',
        '(compunit (capture (char a)))'
    ],
    [
        '[a]',
        '(compunit (group (char a)))'
    ],
    [
        '<[a]>',
        '(compunit (charclass a))'
    ],
    [
        'fo ** 3',
        '(compunit (char f) (repeat (char o) 3))'
    ],
    [
        'fo ** 3 .. 5',
        '(compunit (char f) (repeat (char o) (range 3 5)))'
    ],
]
