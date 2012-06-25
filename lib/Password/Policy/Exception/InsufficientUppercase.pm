package Password::Policy::Exception::InsufficientUppercase;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password did not have enough uppercase characters"; }

1;

__END__
