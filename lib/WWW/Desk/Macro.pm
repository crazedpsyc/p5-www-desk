package WWW::Desk::Macro;
# ABSTRACT: A Macro from the Desk.com API

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
    $self->desk->request( 'GET', '/macros/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub name          { shift->obj->{macro}{name} }
sub enabled       { shift->obj->{macro}{enabled} }

1;
