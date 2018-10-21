package PerlBlue::Redis;

use MooseX::Singleton;
use namespace::autoclean;
use AnyEvent::Redis;

use PerlBlue;

has redis => (
    is          => 'rw',
    required    => 1,
    isa         => 'AnyEvent::Redis',
    handles     => [qw(set get del expire incrby decrby ttl)],
    lazy        => 1,
    default     => sub {
        my $config = PerlBlue->config;
        my $redis = AnyEvent::Redis->new(
        	host => $config->get('redis/host'),
        	port => $config->get('redis/port'),
        );

print STDERR "IN REDIS DEFAULT: [$redis]\n";
        return $redis;
    },
);


sub exists {
    my ($self, $key) = @_;

    print STDERR "EXISTS: [$self][$key]\n";
    return $self->redis->exists($key);
}
__PACKAGE__->meta->make_immutable;

