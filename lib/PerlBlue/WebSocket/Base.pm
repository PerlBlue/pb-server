package PerlBlue::WebSocket::Base;

use Moose;
use namespace::autoclean;



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


# Parent object, which holds the persistent data
#
has parent => (
    is          => 'ro',
    required    => 1,
    isa         => 'PB::WebSocket',
    handles     => [qw(client_data shared_data send render_json broadcast_json)]
);

# Connection (this will persist for the duration of the connection)
#
has connection => (
    is          => 'ro',
    required    => 1,
);


sub log {
    my ($self) = @_;
    my $server = "Base";
    return Log::Log4perl->get_logger( __PACKAGE__ );
}

# Get the data that this instance shared in a namespace
#
sub my_shared_data {
    my ($self, $namespace) = @_;

    my $shared_data = $self->parent->shared_data->{$self->connection}{$namespace} || {};
    $self->log->debug("SHARED DATA: ".Dumper($self->parent->shared_data));

    return $self->parent->shared_data->{$self->connection}{$namespace};
}

__PACKAGE__->meta->make_immutable;
