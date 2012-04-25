package WWW::Desk::Group;
# ABSTRACT: A Group from the Desk.com API

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
    $self->desk->request( 'GET', '/groups/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub created_at   { shift->obj->{group}{created_at} }
sub updated_at   { shift->obj->{group}{updated_at} }
sub name         { shift->obj->{group}{name} }

1;
