package WWW::Desk::Topic;
# ABSTRACT: A Topic from the Desk.com API

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
    $self->desk->request( 'GET', '/topics/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub name { shift->obj->{topic}{name} }
sub description { shift->obj->{topic}{description} }
sub show_in_portal { int(shift->obj->{topic}{show_in_portal}) }


1;
