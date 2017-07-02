package PerlBlue::WebSocket;

use Moose;
use namespace::autoclean;


extends 'PB::WebSocket';

__PACKAGE__->meta->make_immutable;
