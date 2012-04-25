package WWW::Desk::Macro::Action;
# ABSTRACT: An Action from the Desk.com API

use Moo;

has slug => (
        is => 'ro',
        required => 1,
);

has parent_id => (
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
    $self->desk->request( 'GET', '/macros/'.$self->parent_id."/actions/".$self->slug );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub enabled       { shift->obj->{action}{enabled} }
sub value         { shift->obj->{action}{value} }

sub update {
    my ( $self, %data ) = @_;
    $self->request( PUT => "/macros/".$self->parent_id."/actions/".$self->slug, %data );
}

1;
