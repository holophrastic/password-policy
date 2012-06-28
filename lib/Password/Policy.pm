package Password::Policy;

# ABSTRACT: Make managing multiple password strength profiles easy

use strict;
use warnings;

use Class::Load;
use Config::Any;
use Try::Tiny;

use Password::Policy::Exception;
use Password::Policy::Exception::EmptyPassword;
use Password::Policy::Exception::InvalidAlgorithm;
use Password::Policy::Exception::InvalidProfile;
use Password::Policy::Exception::InvalidRule;
use Password::Policy::Exception::NoAlgorithm;
use Password::Policy::Exception::ReusedPassword;

sub new {
    my ($class, %args) = @_;

    my $config_file = $args{config};
    my $previous = $args{previous} || [];

    my $config = Config::Any->load_files({ files => [ $config_file ], use_ext => 1 });
    my $rules = {};

    $config = $config->[0]->{$config_file};
    my @profiles = keys(%{$config});

    my $self = bless {
        _config => $config,
        _rules => $rules,
        _previous => $previous,
        _profiles => \@profiles
    } => $class;

    foreach my $key (@profiles) {
        $rules->{$key} = $self->_parse_rules($key);
    }

    $self->{_rules} = $rules;
    return $self;
}

sub _parse_rules {
    my ($self, $profile_name) = @_;
    my $rules;

    my $profile = $self->config->{$profile_name};
    if(my $parent = delete $profile->{inherit}) {
        $rules = $self->_parse_rules($parent);
    }
    foreach my $key (keys(%{$profile})) {
        if($key eq 'algorithm') {
            $rules->{algorithm} = $profile->{$key};
            next;
        }
        if($rules->{$key}) {
            $rules->{$key} = $profile->{$key} if($profile->{$key} > $rules->{$key});
        } else {
            $rules->{$key} = $profile->{$key};
        }
    }
    return $rules;
}

sub config {
    return (shift)->{_config};
}

sub profiles {
    return (shift)->{_profiles};
}

sub previous {
    return (shift)->{_previous};
}

sub rules {
    my $self = shift;
    my $profile = shift || 'default';
    my $rules = $self->{_rules};
    return $rules->{$profile} || Password::Policy::Exception::InvalidProfile->throw;
}


sub process {
    my ($self, $args) = @_;
    my $password = $args->{password} || Password::Policy::Exception::EmptyPassword->throw;

    my $rules = $self->rules($args->{profile});
    my $algorithm = $rules->{algorithm} || Password::Policy::Exception::NoAlgorithm->throw;
    foreach my $rule (keys(%{$rules})) {
        next if($rule eq 'algorithm');

        my $rule_class = 'Password::Policy::Rule::' . ucfirst($rule);
        try {
            Class::Load::load_class($rule_class);
        } catch {
            Password::Policy::Exception::InvalidRule->throw;
        };
        my $rule_obj = $rule_class->new($rules->{$rule});
        my $check = $rule_obj->check($password);
        unless($check) {
            # no idea what failed if we didn't get a more specific exception, so
            # throw a generic error
            Password::Policy::Exception->throw;
        }
    }
    my $enc_password = $self->encrypt($algorithm, $password);

    # This is a post-encryption rule, so it's a special case.
    if($self->previous) {
        foreach my $previous_password (@{$self->previous}) {
            Password::Policy::Exception::ReusedPassword->throw if($enc_password eq $previous_password);
        }
    }
    return $enc_password;
}

sub encrypt {
    my ($self, $algorithm, $password) = @_;

    unless($algorithm) { Password::Policy::Exception::NoAlgorithm->throw; }
    unless($password) { Password::Policy::Exception::EmptyPassword->throw; }

    my $enc_class = 'Password::Policy::Encryption::' . $algorithm;
    try {
        Class::Load::load_class($enc_class);
    } catch {
        Password::Policy::Exception::InvalidAlgorithm->throw;
    };
    my $enc_obj = $enc_class->new;
    my $new_password = $enc_obj->enc($password);
    return $new_password;
}

1;

__END__
