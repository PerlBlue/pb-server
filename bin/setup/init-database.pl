#!/usr/bin/env perl

use strict;
use 5.010;

use lib '/home/perlblue/pb-server/lib';

use PerlBlue;

my $config = PerlBlue->config;
my $db = PerlBlue->db;

say "Deploying Database";
$db->deploy({ add_drop_table => 1});


