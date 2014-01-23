package PSR;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";



1;
__END__

=encoding utf-8

=head1 NAME

PSR - Perl6 regular expressions

=head1 SYNOPSIS

    use PSR::Converter::Perl5;
    use PSR::Parser;

    my $node = PSR::Parser->new()->parse('^a');
    my $re = PSR::Converter::Perl5->new->convert($node);
    # $re is qr{\Aa}m

=head1 DESCRIPTION

PSR is utilities for Perl6 regular expressions.

This module can convert Perl6 regular expressions to Perl5 regular expression.

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=cut

