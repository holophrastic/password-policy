package Password::Policy::Exception::InvalidProfile;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified profile does not exist"; }

1;

__END__
