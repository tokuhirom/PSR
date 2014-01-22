use strict;
use warnings;
use utf8;
use Test::More;
use JKML;
use PSR::Converter::Perl5;
use PSR::Parser;

for my $block (@{decode_jkml(join '', <DATA>)}) {
    my ($p6, $p5) = @$block;
    my $node = PSR::Parser->new->parse($p6);
    my $p5re = PSR::Converter::Perl5->convert($node);
    my $sexp = $node->as_sexp;
    note $sexp;
    is $p5re, qr!$p5!m, $p6;
}

done_testing;

__DATA__
[
    [ r'.',        r'.',         ],
    [ r'^a',       r'\Aa',       ],
    [ r'^^a',      r'^a',        ],
    [ r'a$',       r'a\z',       ],
    [ r'a$$',      r'a$',        ],
    [ r'<[abc]>',  r'[abc]',     ],
    [  r'a?',      r'a?',        ],
    [  r'a*',      r'a*',        ],
    [  r'a+',      r'a+',        ],
    [ r'a??',      r'a??',       ],
    [ r'a*?',      r'a*?',       ],
    [ r'a+?',      r'a+?',       ],
    [ r'a|b',      r'a|b',       ],
    [ r'[a|b]',    r'(?:a|b)',   ],
    [ r'(a|b)',    r'(a|b)',     ],
    [ r"'ho.'*",   r'(?:ho\.)*', ],
    [ r'a**3',     r'a{3}',      ],
    [ r'a**3..5',  r'a{3,5}',    ],
]
