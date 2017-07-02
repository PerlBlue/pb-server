#!/usr/bin/env perl

use strict;
use warnings;
#use v5.20;
use lib "/home/perlblue/pb-server/lib";

use AnyEvent;
use AnyEvent::Socket qw(tcp_server);
use AnyEvent::Redis;

use PerlBlue;
use PerlBlue::WebSocket;

use PB::Queue;
use Data::Dumper;

use Log::Log4perl;

my $config = PerlBlue->config->get();
my $client_url = $config->{client_url};
my $condvar = AnyEvent->condvar;

Log::Log4perl->init('/home/perlblue/pb-server/etc/log4perl.conf');
my $log = Log::Log4perl->get_logger('WS');


my $web_socket = PerlBlue::WebSocket->new;

#--- Web Socket handler
#
tcp_server 0, 80, sub {
    my ($fh) = @_;
    $web_socket->call($fh);
};

#--- beanstalk handler
my $queue = PB::Queue->instance;

# Watch the foreground message queue.
$queue->watch('fg_websocket');

# Subscribe to the Building PubSub channel
#my $pipe = PB::PubSub->subscribe('ps_building');
#$log->debug("PS_BUILDING subscribe [$pipe]");

while (1) {
    my $job = $queue->consume;

    # The message is handled by the WebSocket queue router
    $web_socket->queue($job);
}

#--- Redis handler
#


$condvar->recv;
print STDERR "WE SHOULD NEVER GET HERE\n";
