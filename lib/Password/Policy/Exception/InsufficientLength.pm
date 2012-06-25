package Password::Policy::Exception::InsufficientLength;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password was not long enough"; }

1;

__END__
