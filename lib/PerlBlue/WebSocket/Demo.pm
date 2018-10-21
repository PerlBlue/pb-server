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
    my ($id) = $context->connection =~ m/\((.*)\)/;

    $shared_data->{id}      = $id;
    $shared_data->{name}    = "Name $id";
    $shared_data->{number}  = 0;
    $shared_data->{status}  = 'enabled';

    $log->debug("ws_register: entry:".Dumper($shared_data));
    $self->broadcast_data();

    return;
}

#--- Validate the message is for me
#
sub _validate {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_enable');

    my ($id) = $context->connection =~ m/\((.*)\)/;

    $log->debug("COMPARE [$id] with [".$context->content->{id}."]\n");
    $log->debug("CONTENT ".Dumper($context->content->{id}));

    return 1 if $id eq $context->content->{id};
    return;
}


#--- Enable a counter
#
sub ws_enable {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_enable');

    if (! $self->_validate($context)) {
        return;
    }

    $log->debug("CONTENT: ".Dumper($context->content));
    $log->debug("CONNECT: ".$context->connection."\n");

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

    if (! $self->_validate($context)) {
        return;
    }

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

    $log->debug("SHARED DATA ".Dumper($self->shared_data));
    my $transmit;
    foreach my $connection (sort keys %{$self->shared_data}) {
        my $data = $self->shared_data->{$connection}{Demo};
        push @$transmit, {
            id      => $data->{id},
            name    => $data->{name},
            number  => $data->{number},
            status  => $data->{status},
        };
    }

    $self->broadcast_json('/demo/status', $transmit);
}


__PACKAGE__->meta->make_immutable;
