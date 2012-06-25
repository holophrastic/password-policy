package Password::Policy::Rule::Numbers;

use strict;
use warnings;

use parent 'Password::Policy::Rule';

use String::Multibyte;

use Password::Policy::Exception::InsufficientNumbers;

sub check {
    my $self = shift;
    my $password = $self->prepare(shift);
    my @numbers = ($password =~ m/(\d)/g);
    my $count = scalar @numbers;
    if($count < $self->arg) {
        Password::Policy::Exception::InsufficientNumbers->throw;
    }
    return 1;
}

1;

__END__
