package PSR::Node;
use strict;
use warnings;
use utf8;
use 5.010_001;
use PSR::Constants;

sub new {
    my ($class, $type, $data) = @_;
    bless {type => $type, data => $data}, $class;
}

sub type { $_[0]->{type} }
sub data { $_[0]->{data} }

sub as_sexp {
    my ($self) = @_;
    my $ret = "(" . $self->type_str;
    if (ref $self->{data} eq 'ARRAY') {
        $ret .= " ";
        $ret .= join(' ', map {
            UNIVERSAL::isa($_, 'PSR::Node') ? $_->as_sexp : $_
        } @{$self->{data}});
    } elsif (UNIVERSAL::isa($self->{data}, 'PSR::Node')) {
        $ret .= ' ' . $self->{data}->as_sexp;
    } elsif (defined $self->{data}) {
        $ret .= " $self->{data}";
    } else {
        # nop.
    }
    return "$ret)";
}

sub type_str {
    my ($self) = @_;

    for (grep /\APSR_NODE_/, @PSR::Constants::EXPORT) {
        if ($self->{type} eq PSR::Constants->$_) {
            (my $name = $_) =~ s/\APSR_NODE_//;
            return lc($name);
        }
    }
    die "Unknown node: $self->{type}";
}

1;

