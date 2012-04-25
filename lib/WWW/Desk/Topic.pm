package WWW::Desk::Topic;
# ABSTRACT: A Topic from the Desk.com API

use Moo;
use WWW::Desk::Article;

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

sub destroy {
    my ( $self ) = @_;
    $self->desk->request( 'DELETE', '/topics/'.$self->id );
}

sub update {
    my ( $self, %data ) = @_;
    $self->request( 'PUT', "/topics/".$self->id, %data );
}

sub get_articles {
    my ( $self, %args ) = @_;
    $self->desk->_make_obj_array("article", "/articles", "WWW::Desk::Article", %args);
}

sub create_article {
    my ( $self, %data ) = @_;
    $self->request( POST => "/topics/".$self->id."/articles", %data );
}

1;
