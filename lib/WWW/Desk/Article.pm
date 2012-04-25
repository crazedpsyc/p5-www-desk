package WWW::Desk::Article;
# ABSTRACT: An Article from the Desk.com API

use Moo;
use WWW::Desk::Article::Translation;

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
    $self->desk->request( 'GET', '/articles/'.$self->id );
}

has desk => (
    is => 'ro',
    required => 1,
);
sub subject         { shift->obj->{article}{subject} }
sub main_content    { shift->obj->{article}{main_content} }
sub show_in_portal  { int(shift->obj->{article}{show_in_portal}) }
sub agent_content   { shift->obj->{article}{agent_content} }
sub email           { shift->obj->{article}{email} }
sub chat            { shift->obj->{article}{chat} }
sub twitter         { shift->obj->{article}{twitter} }
sub question_answer { shift->obj->{article}{question_answer} }
sub phone           { shift->obj->{article}{phone} }
sub quickcode       { shift->obj->{article}{quickcode} }
sub published_at    { shift->obj->{article}{published_at} }
sub updated_at      { shift->obj->{article}{updated_at} }
sub created_by      { shift->obj->{article}{created_by} }
sub updated_by      { shift->obj->{article}{updated_by} }

sub translations    { 
    my $rawtranslations = shift->obj->{article}{translations};
    my @translations;
    push @translations, WWW::Desk::Article::Translation->new($$_{article_translation}) for @$rawtranslations;
    @translations;
}

sub get_translation {
    my ( $self, $locale ) = @_;
    for ($self->translations) {
        return $_ if $_->locale eq $locale;
    }
}

1;
