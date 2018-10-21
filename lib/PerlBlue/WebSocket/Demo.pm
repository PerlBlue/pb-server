package PerlBlue::WebSocket::Demo;

use Moose;
use Log::Log4perl;
use Data::Dumper;
use Text::Trim qw(trim);
use Email::Valid;
use Time::HiRes qw(gettimeofday);
use AnyEvent;


use PerlBlue;
use PerlBlue::SDB;
use PerlBlue::Cache;
use PB::ClientCode;
use PB::Queue;
use PB::Config;

extends 'PerlBlue::WebSocket::Base';

sub log {
    my ($self) = @_;
    my $server = "Demo";
    return Log::Log4perl->get_logger( __PACKAGE__ );
}

#--- Register a new counter on the demo page
#
sub ws_register {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_register');
    $log->debug("XXXXXX GOT HERE XXXXXXXX\n");

    # Create a new store for this counter instance.
    my $shared_data = $self->my_shared_data('Demo');

    $log->debug("SHARED DATA [$shared_data]\n");



    $shared_data->{
        id      => $context->connection,
        name    => "Name ".$context->connection,
        number  => 0,
        status  => 'enabled',
    };
    $log->debug("ws_register: entry:".Dumper($shared_data));
    $self->broadcast_data();

    return;
}

#--- Enable a counter
#
sub ws_enable {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_enable');

    #my $id = $context->content->{id};

    my $shared_data = $self->my_shared_data('Demo');
    $shared_data->{status} = 'enabled';
    $shared_data->{number}++;

    $self->broadcast_data();
    return;
}

#--- Disable a counter
#
sub ws_disable {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_disable');

    my $shared_data = $self->my_shared_data('Demo');
    $shared_data->{status} = 'disabled';
    $shared_data->{number}++;

    $self->broadcast_data();
    return;
}

#--- Broadcast the state of all counters to every connection
#
sub broadcast_data {
    my ($self) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_register');

    $self->broadcast_json('/demo/status', $self->my_shared_data('Demo'));
}


__PACKAGE__->meta->make_immutable;
