package WWW::Desk::Article::Translation;
# ABSTRACT: An Article translation from the Desk.com API

use Moo;

has locale => (
        is => 'ro',
        required => 1,
);

has subject => (
        is => 'ro',
        required => 1,
);

has main_content => (
        is => 'ro',
        required => 1,
);

has agent_content => (
        is => 'ro',
        required => 1,
);

has email => (
        is => 'ro',
        required => 1,
);

has chat => (
        is => 'ro',
        required => 1,
);

has twitter => (
        is => 'ro',
        required => 1,
);

has question_answer => (
        is => 'ro',
        required => 1,
);

has phone => (
        is => 'ro',
        required => 1,
);

has facebook => (
        is => 'ro',
        required => 1,
);

has updated_at => (
        is => 'ro',
        required => 1,
);

has published_at => (
        is => 'ro',
);

has out_of_date => (
        is => 'ro',
        required => 1,
);

1;
