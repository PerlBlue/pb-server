#!/usr/bin/env perl

use strict;
use 5.010;

use lib '/home/perlblue/pb-server/lib';

use PB;

my $config = PB->config;
my $db = PB->db;

say "Deploying Database";
$db->deploy({ add_drop_table => 1});


