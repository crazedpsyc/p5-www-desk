package WWW::Desk::User;
# ABSTRACT: A User from the Desk.com API

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
    $self->desk->request( 'GET', '/users/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub name_public   { shift->obj->{user}{name_public} }
sub name          { shift->obj->{user}{name} }
sub last_login_at { shift->obj->{user}{last_login_at} }
sub login_count   { shift->obj->{user}{login_count} }
sub email         { shift->obj->{user}{email} }
sub created_at    { shift->obj->{user}{created_at} }
sub updated_at    { shift->obj->{user}{updated_at} }
sub time_zone     { shift->obj->{user}{time_zone} }
sub user_level    { shift->obj->{user}{user_level} }

1;
