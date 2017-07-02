package PerlBlue;

use strict;
use Module::Find qw(useall);

use PerlBlue::SDB;
use PerlBlue::Redis;
use PB::Cache;
use PB::Queue;
use PB::Config;


use Config::JSON;

useall __PACKAGE__;

our $VERSION = 3.0923;

PB::Config->initialize({
    filename    => '/home/perlblue/pb-server/etc/perlblue.conf',
});

my $config = Config::JSON->new('/home/perlblue/pb-server/etc/perlblue.conf');


my $redis = PerlBlue::Redis->instance;

my $cache = PB::Cache->new(
    redis => $redis,
);
#servers => $config->get('memcached'));


PB::Queue->initialize({
   server      => $config->get('beanstalk/server')
});


my $queue = PB::Queue->instance;

sub version {
    return $VERSION;
}

sub config {
    return $config;
}

sub db {
    #return $db;
    PerlBlue::SDB->instance->db;
}

sub cache {
    return $cache;
}

sub queue {

    return $queue;
}

1;
