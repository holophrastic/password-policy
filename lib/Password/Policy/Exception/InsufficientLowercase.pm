package Password::Policy::Exception::InsufficientLowercase;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password did not have enough lowercase ASCII characters"; }

1;

__END__
