package PerlBlue::MessageQueue;

use Moose;
use namespace::autoclean;


extends 'PB::MessageQueue';

__PACKAGE__->meta->make_immutable;
