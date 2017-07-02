package PerlBlue::SDB;

use MooseX::Singleton;
use namespace::autoclean;

use PerlBlue;
use PB::DB;

has db => (
    is          => 'rw',
    required    => 1,
    isa         => 'PB::DB',
    #handles     => [qw(resultset)],
    default     => sub {
        my $config = PerlBlue->config;
        my $db = PB::DB->connect(
            $config->get('db/dsn'),
            $config->get('db/username'),
            $config->get('db/password'),
            {
                mysql_enable_utf8 => 1,
                AutoCommit        => 1,
            }
        );
    }
);

__PACKAGE__->meta->make_immutable;

