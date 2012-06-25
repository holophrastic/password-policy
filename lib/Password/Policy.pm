package Password::Policy;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    my $config = $args{'config'};
    my $previous = $args{'previous'} || {};

    my @rules;

    my $self = bless {
        rules => \@rules,
        previous => $previous
    } => $class;
    return $self;
}

1;

__END__
