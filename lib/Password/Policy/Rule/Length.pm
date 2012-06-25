package Password::Policy::Rule::Length;

use strict;
use warnings;

use parent 'Password::Policy::Rule';

use String::Multibyte;

use Password::Policy::Exception::InsufficientLength;

sub default_arg { return 8; }

sub check {
    my $self = shift;
    my $password = $self->prepare(shift);
    my $strmb = String::Multibyte->new('UTF8');
    my $len = $strmb->length($password);
    if($len < $self->arg) {
        Password::Policy::Exception::InsufficientLength->throw;
    }
    return 1;
}

1;

__END__
