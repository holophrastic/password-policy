package Password::Policy::Exception::InvalidRule;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "You specified a rule that is not available"; }

1;

__END__
