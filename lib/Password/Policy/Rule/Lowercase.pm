package Password::Policy::Rule::Lowercase;

use strict;
use warnings;

use parent 'Password::Policy::Rule';

use String::Multibyte;

use Password::Policy::Exception::InsufficientLowercase;

sub check {
    my $self = shift;
    my $password = $self->prepare(shift);
    my @lowercase = ($password =~ m/[a-z]/g);
    my $count = scalar @lowercase;
    if($count < $self->arg) {
        Password::Policy::Exception::InsufficientLowercase->throw;
    }
    return 1;
}

1;

__END__
