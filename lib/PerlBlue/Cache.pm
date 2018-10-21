package PerlBlue::Cache;

use Moose;
use namespace::autoclean;

extends 'PB::Cache';

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
