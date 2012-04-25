package WWW::Desk::Customer;
# ABSTRACT: A Customer from the Desk.com API

use Moo;

has id => (
        is => 'ro',
        required => 1,
);

has obj => (
        is => 'ro',
        builder => '_build_obj',
        lazy => 1,
);

sub _build_obj {
    my $self = shift;
    $self->desk->request( 'GET', '/customers/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub twitters     { shift->obj->{customer}{twitters} }
sub custom_test  { shift->obj->{customer}{custom_test} }
sub phones       { shift->obj->{customer}{phones} }
sub custom_t     { shift->obj->{customer}{custom_t} }
sub last_name    { shift->obj->{customer}{last_name} }
sub custom_i     { shift->obj->{customer}{custom_i} }
sub addresses    { shift->obj->{customer}{addresses} }
sub emails       { shift->obj->{customer}{emails} }
sub custom_order { shift->obj->{customer}{custom_order} }
sub first_name   { shift->obj->{customer}{first_name} }
sub custom_t2    { shift->obj->{customer}{custom_t2} }
sub custom_t3    { shift->obj->{customer}{custom_t3} }

1;
