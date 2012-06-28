package Password::Policy::Exception::ReusedPassword;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "You specified a password you have used too recently"; }

1;

__END__
