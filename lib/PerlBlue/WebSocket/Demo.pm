package PerlBlue::WebSocket::Demo;

use Moose;
use Log::Log4perl;
use Data::Dumper;
use Text::Trim qw(trim);
use Email::Valid;
use Time::HiRes qw(gettimeofday);
#use List::Util qw(min);

use PerlBlue::SDB;
use PB::ClientCode;
use PB::Queue;
use PB::Config;


has data => (
    is      => 'rw',
    #isa     => 'ArrayRef',
    #default => sub { [] },
);

# A user has joined the server
#
sub on_connect {
    my ($self, $context) = @_;

    return {
        message     => 'Welcome to PerlBlue User server',
    };
}

sub log {
    my ($self) = @_;
    my $server = "Demo";
    return Log::Log4perl->get_logger( __PACKAGE__ );
}

#--- Register a new demo
#
sub ws_register {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_register');

    my @data;
    foreach my $id (0,1,2,3) {
        push @data, {
            id      => $id,
            enabled => 1,
            value   => 0,
        }
    }
    $self->data(\@data);

    $log->debug("ws_register: entry:".Dumper($self->data));
}

#--- Enable a counter
#
sub ws_enable {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_enable');
    $log->debug("ws_enable: entry: ".Dumper($context->content));
}

#--- Disable a counter
#
sub ws_disable {
    my ($self, $context) = @_;

    my $log = Log::Log4perl->get_logger('PerlBlue::WebSocket::Demo::ws_disable');
    $log->debug("ws_disable: entry: ".Dumper($context->content));
}

1;
