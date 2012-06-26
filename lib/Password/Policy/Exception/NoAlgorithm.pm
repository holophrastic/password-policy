package Password::Policy::Exception::NoAlgorithm;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "You did not specify an algorithm for that profile"; }

1;

__END__
