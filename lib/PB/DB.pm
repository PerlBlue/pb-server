package PB::DB;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends qw/DBIx::Class::Schema/;

# DeploymentHandler version
our $VERSION = 1;

__PACKAGE__->load_namespaces();

sub sqlt_deploy_hook {
    my ($self, $sqlt_schema) = @_;
    $sqlt_schema->drop_table('noexist_basetable');
    $sqlt_schema->drop_table('noexist_log');
    $sqlt_schema->drop_table('noexist_map');
}

no Moose;
__PACKAGE__->meta->make_immutable;
