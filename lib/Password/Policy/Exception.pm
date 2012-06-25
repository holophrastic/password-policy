package Password::Policy::Exception;

use strict;
use warnings;

use overload 
    '""' => sub { shift->error },
    'cmp'   => \&_three_way_compare;


sub new { bless {} => shift; }
sub error { return "An unspecified exception was thrown."; }
sub throw { die shift->new; }

sub _three_way_compare {
    my $self = shift;
    my $other = shift || '';
    return $self->error cmp "$other";
}

1;

__END__
