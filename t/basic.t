#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('Password::Policy');
}

my $test_yml_loc = "/Users/anelson/ext_src/password-policy/test_config/sample.yml";

my $pp = Password::Policy->new(config => $test_yml_loc);

use DDP;
p $pp;


done_testing;
