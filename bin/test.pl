#!/usr/bin/env perl

use strict;
use warnings;
#use v5.20;
use lib "/home/perlblue/pb-server/lib";

use AnyEvent;
use AnyEvent::Socket qw(tcp_server);
use PerlBlue::Cache;
use PerlBlue::Redis;

use PerlBlue;


use PerlBlue::WebSocket;

use PB::Queue;
use Data::Dumper;

use Log::Log4perl;

my $config = PerlBlue->config->get();
my $client_url = $config->{client_url};

Log::Log4perl->init('/home/perlblue/pb-server/etc/log4perl.conf');
my $log = Log::Log4perl->get_logger('WS');

my $condvar = AnyEvent->condvar;


use Data::Dumper;
my $redis = PerlBlue->redis;
print STDERR "REDIS: ".Dumper($redis);

my $cache = PerlBlue->cache->redis;
print STDERR "CACHE: $cache\n";

$cache->set('PB','test',1);


my $value = $cache->get('PB','test');

print STDERR "cache get: [$value]\n";

while (1) {
	sleep(1);
	$cache->get('PB','test', sub {
		my ($value) = @_;

		print STDERR "Got [$value]\n";
	});
}

$condvar->recv;

