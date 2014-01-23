# NAME

PSR - Perl6 regular expressions

# SYNOPSIS

    use PSR::Converter::Perl5;
    use PSR::Parser;

    my $node = PSR::Parser->new()->parse('^a');
    my $re = PSR::Converter::Perl5->new->convert($node);
    # $re is qr{\Aa}m

# DESCRIPTION

PSR is utilities for Perl6 regular expressions.

This module can convert Perl6 regular expressions to Perl5 regular expression.

# LICENSE

Copyright (C) Tokuhiro Matsuno.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Tokuhiro Matsuno <tokuhirom@gmail.com>
