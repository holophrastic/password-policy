package Password::Policy::Encryption;

use strict;
use warnings;

use Password::Policy::Exception::EmptyPassword;

sub new { bless {} => shift; }
sub enc { return "This was not implemented properly."; }

# alias
sub encrypt {
    my ($self, $arg) = @_;
    return $self->enc($arg);
}

sub prepare {
    my ($self, $password) = @_;
    return $password || Password::Policy::Exception::EmptyPassword->throw;
}

1;

__END__
