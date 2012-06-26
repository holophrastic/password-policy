package Password::Policy::Exception::InsufficientWhitespace;

use strict;
use warnings;

use parent 'Password::Policy::Exception';

sub error { return "The specified password did not have enough whitespace characters"; }

1;

__END__
