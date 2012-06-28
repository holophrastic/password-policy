package Password::Policy::Exception::InvalidAlgorithm;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "You specified an algorithm that is not available"; }

1;

__END__
