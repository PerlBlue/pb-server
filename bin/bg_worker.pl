#!/usr/bin/perl

use lib '/home/perlblue/pb-server/lib';
use Log::Log4perl;

use PerlBlue;
use PB::Config;

use PB::App::MQWorker;

Log::Log4perl->init('/home/perlblue/pb-server/etc/log4perl.conf');

my $app = PB::App::MQWorker->new_with_command();

$app->run;


