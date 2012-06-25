package Password::Policy::Exception::InsufficientNumbers;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password did not have enough numbers"; }

1;

__END__
