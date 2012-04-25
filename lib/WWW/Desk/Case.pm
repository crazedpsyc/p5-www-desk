package WWW::Desk::Case;
# ABSTRACT: A Case from the Desk.com API

use Moo;

has id => (
        is => 'ro',
        required => 1,
);

has by => (
    is => 'ro',
);

has obj => (
        is => 'ro',
        builder => '_build_obj',
        lazy => 1,
);

sub _build_obj {
    my $self = shift;
    return $self->desk->request( 'GET', '/cases/'.$self->id, by => $self->by ) if defined $self->by;
    $self->desk->request( 'GET', '/cases/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);

sub external_id         { shift->obj->{case}{external_id} }
sub last_available_at   { shift->obj->{case}{last_available_at} }
sub created_at          { shift->obj->{case}{created_at} }
sub active_at           { shift->obj->{case}{active_at} }
sub route_at            { shift->obj->{case}{route_at} }
sub first_discovered_at { shift->obj->{case}{first_discovered_at} }
sub active_user         { shift->obj->{case}{active_user} }
sub updated_at          { shift->obj->{case}{updated_at} }
sub case_status_at      { shift->obj->{case}{case_status_at} }
sub priority            { shift->obj->{case}{priority} }
sub last_saved_by_id    { shift->obj->{case}{last_saved_by_id} }
sub interaction_in_at   { shift->obj->{case}{interaction_in_at} }
sub assigned_at         { shift->obj->{case}{assigned_at} }
sub subject             { shift->obj->{case}{subject} }
sub routed_at           { shift->obj->{case}{routed_at} }
sub group               { shift->obj->{case}{group} }
sub user                { shift->obj->{case}{user} }
sub first_opened_at     { shift->obj->{case}{first_opened_at} }
sub channel             { shift->obj->{case}{channel} }
sub resolved_at         { shift->obj->{case}{resolved_at} }
sub description         { shift->obj->{case}{description} }
sub customer_id         { shift->obj->{case}{customer_id} }
sub closed_at           { shift->obj->{case}{closed_at} }
sub changed_at          { shift->obj->{case}{changed_at} }
sub case_status_type    { shift->obj->{case}{case_status_type} }
sub labels              { shift->obj->{case}{labels} }
sub pending_at          { shift->obj->{case}{pending_at} }
sub opened_at           { shift->obj->{case}{opened_at} }
sub route_status        { shift->obj->{case}{route_status} }
sub thread_count        { shift->obj->{case}{thread_count} }
sub note_count          { shift->obj->{case}{note_count} }
sub preview             { shift->obj->{case}{preview} }
sub macros              { shift->obj->{case}{macros} }
sub articles            { shift->obj->{case}{articles} }

sub update {
    my ( $self, %data ) = @_;
    $self->request( 'PUT', "/cases/".$self->id, %data );
}


1;

