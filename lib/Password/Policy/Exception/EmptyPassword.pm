package Password::Policy::Exception::EmptyPassword;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password was empty"; }

1;

__END__
