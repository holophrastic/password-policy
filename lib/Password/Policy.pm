package Password::Policy;

# ABSTRACT: Make managing multiple password strength profiles easy

use strict;
use warnings;

use Class::Load;
use Config::Any;

use Password::Policy::Exception::EmptyPassword;
use Password::Policy::Exception::InvalidProfile;
use Password::Policy::Exception::NoAlgorithm;

sub new {
    my ($class, %args) = @_;

    my $config_file = $args{config};
    my $previous = $args{previous} || \[];

    my $config = Config::Any->load_files({ files => [ $config_file ], use_ext => 1 });
    my $rules = {};

    my $self = bless {
        _config => $config->[0]->{$config_file},
        _rules => $rules,
        _previous => $previous
    } => $class;

    foreach my $key (keys(%{$self->config})) {
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
    my $algorithm = delete $rules->{algorithm} || Password::Policy::Exception::NoAlgorithm->throw;
    foreach my $rule (@{$rules}) {
        my $rule_class = 'Password::Policy::Rule::' . ucfirst($rule->{type});
        Class::Load::load_class($rule_class);
        my $rule_obj = $rule_class->new($rule->{arg});
        my $check = $rule_obj->check($password);
        unless($check) {
            # no idea what failed if we didn't get a more specific exception, so
            # throw a generic error
            Password::Policy::Exception->throw;
        }
    }

    my $enc_class = 'Password::Policy::Encryption::' . $algorithm;
    Class::Load::load_class($enc_class);
    my $enc_obj = $enc_class->new;
    my $new_password = $enc_obj->enc($password);
    return $new_password;
}

1;

__END__
