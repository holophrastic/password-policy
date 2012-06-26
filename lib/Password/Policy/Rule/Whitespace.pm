package Password::Policy::Rule::Whitespace;

use strict;
use warnings;

use parent 'Password::Policy::Rule';

use String::Multibyte;

use Password::Policy::Exception::InsufficientWhitespace;

sub check {
    my $self = shift;
    my $password = $self->prepare(shift);
    my @whitespace = ($password =~ m/\s/g);
    my $count = scalar @whitespace;
    if($count < $self->arg) {
        Password::Policy::Exception::InsufficientWhitespace->throw;
    }
    return 1;
}

1;

__END__
