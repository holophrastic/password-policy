package Password::Policy::Encryption::ROT13;

use strict;
use warnings;

use parent 'Password::Policy::Encryption';

use String::Multibyte;

sub enc {
    my $self = shift;
    my $password = $self->prepare(shift);
    my $strmb = String::Multibyte->new('UTF8');
    return $strmb->strrev($password);
}

1;

__END__


