package WWW::Desk::Interaction;
# ABSTRACT: An Interaction from the Desk.com API

use Moo;

has id => (
        is => 'ro',
        required => 1,
);

has desk => (
    is => 'ro',
    required => 1,
);



1;

