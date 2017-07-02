package PerlBlue::Redis;

use MooseX::Singleton;
use namespace::autoclean;
use Redis;

use PerlBlue;

has redis => (
    is          => 'rw',
    required    => 1,
    isa         => 'Redis',
    handles     => [qw(set get del expire incrby decrby)],
    default     => sub {
        my $config = PerlBlue->config;
        Redis->new(server => join(':', $config->get('redis/host'), $config->get('redis/port')));
    },
);

__PACKAGE__->meta->make_immutable;

