package WWW::Desk::Macro;
# ABSTRACT: A Macro from the Desk.com API

use Moo;
use WWW::Desk::Macro::Action;

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

sub update {
    my ( $self, %data ) = @_;
    $self->request( PUT => "/macros/".$self->id, %data );
}

sub destroy {
    my ( $self ) = @_;
    $self->desk->request( 'DELETE', '/macros/'.$self->id );
}

sub get_actions {
    my ( $self, %args ) = @_;
    my @raw = @{$self->desk->request( GET => "/macros/".$self->id."/actions", %args )->{results}};
    my @objects;
    for (@raw) {
        push @objects, WWW::Desk::Macro::Action->new(
                slug => $$_{action}{slug},
                desk => $self->desk,
                obj => $_,
                parent_id => $self->id,
        );
    }
    \@objects;
}

sub get_action {
    my ( $self, $slug ) = @_;
    WWW::Desk::Macro::Action->new( 
            slug => $slug,
            desk => $self->desk,
            parent_id => $self->id,
    );
}

1;
