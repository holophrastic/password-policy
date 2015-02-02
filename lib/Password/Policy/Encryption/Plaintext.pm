package Password::Policy::Encryption::Plaintext;

use strict;
use warnings;

use parent 'Password::Policy::Encryption';

sub enc {
    my $self = shift;
    my $password = $self->prepare(shift);
    return $password;
}

1;

__END__


