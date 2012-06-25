package Password::Policy::Rule;

use strict;
use warnings;

use Password::Policy::Exception::EmptyPassword;

sub new {
    my $class = shift;
    my $arg = shift || 0;

    my $self = bless {
        arg => $arg
    } => $class;
    return $self;
}

sub arg {
    my $self = shift;
    return $self->{arg} || $self->default_arg;
}

sub check { return "This was not implemented properly."; }
sub default_arg { return 1; }

sub prepare {
    my ($self, $password) = @_;
    return $password || Password::Policy::Exception::EmptyPassword->throw;
}

1;

__END__
