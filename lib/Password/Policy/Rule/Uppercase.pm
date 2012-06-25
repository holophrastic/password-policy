package Password::Policy::Rule::Uppercase;

use strict;
use warnings;

use parent 'Password::Policy::Rule';

use String::Multibyte;

use Password::Policy::Exception::InsufficientUppercase;

sub check {
    my $self = shift;
    my $password = $self->prepare(shift);
    my @uppercase = ($password =~ m/[A-Z]/g);
    my $count = scalar @uppercase;
    if($count < $self->arg) {
        Password::Policy::Exception::InsufficientUppercase->throw;
    }
    return 1;
}

1;

__END__
