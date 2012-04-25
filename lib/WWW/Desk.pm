package WWW::Desk;
# ABSTRACT: Query the Desk.com API

use Moo;
use LWP::UserAgent;
use HTTP::Request;
use Net::OAuth::ProtectedResourceRequest;
use JSON;
use URI::Escape;

use WWW::Desk::Topic;
use WWW::Desk::Article;
use WWW::Desk::Case;

our $VERSION ||= '0.0development';

has consumer_key => (
        is => 'ro',
        required => 1,
);

has consumer_secret => (
        is => 'ro',
        required => 1,
);

has access_token => (
        is => 'ro',
        required => 1,
);

has access_secret => (
        is => 'ro',
        required => 1,
);

has subdomain => (
        is => 'ro',
        required => 1,
);

sub _build__http_agent {
    my $self = shift;
    my $ua = LWP::UserAgent->new;
    $ua->agent($self->http_agent_name);
    $ua;
}

has _http_agent => (
        is => 'ro',
        lazy => 1,
        builder => '_build__http_agent',
);

sub _build_http_agent_name { __PACKAGE__.'/'.$VERSION }

has http_agent_name => (
        is => 'ro',
        lazy => 1,
        builder => '_build_http_agent_name',
);

sub _protected_resource_request {
    my ( $self, $method, $url, $data ) = @_;
    my %data = %$data;
    my $request = Net::OAuth::ProtectedResourceRequest->new(
        request_url => $url,
        request_method => $method,
        consumer_key => $self->consumer_key,
        consumer_secret => $self->consumer_secret,
        token => $self->access_token,
        token_secret => $self->access_secret,
        signature_method => 'HMAC-SHA1',
        timestamp => time,
        nonce => int(rand(2 ** 32)),
        extra_params => \%data,
    );
    $request->sign;
    $request;
}

sub base_url { "https://".shift->subdomain.".desk.com/api/v1" }

sub request { 
    my ( $self, $method, $path, %data ) = @_;
    my $url = $self->base_url.$path.".json";
    my $oauth_req = $self->_protected_resource_request( $method, $url, \%data );
    $oauth_req->request_method($method);
    my $request = HTTP::Request->new( $method => $oauth_req->to_url );

    my $response = $self->_http_agent->request( $request );
    if ($response->is_success) {
        return decode_json $response->content;
    } else {
        die __PACKAGE__.' HTTP request failed: '.$response->status_line, "\n";
    }
}

#
# Topics
#
sub get_topic {
    my ( $self, $id ) = @_;
    WWW::Desk::Topic->new( 
            id => $id,
            desk => $self,
    );
}

sub create_topic {
    my ( $self, %data ) = @_;
    $self->request( 'POST', "/topics", %data );
}

sub update_topic {
    my ( $self, $id, %data ) = @_;
    $self->request( 'PUT', "/topics/$id", %data );
}

sub destroy_topic {
    my ( $self, $id ) = @_;
    $self->request( 'DELETE', "/topics/$id" );
}

#
# Articles
#
sub get_article {
    my ( $self, $id ) = @_;
    WWW::Desk::Article->new( 
            id => $id,
            desk => $self,
    );
}

sub create_article {
    my ( $self, $topicid, %data ) = @_;
    $self->request( 'POST', "/topics/$topicid/articles", %data );
}

sub update_article {
    my ( $self, $id, %data ) = @_;
    $self->request( 'PUT', "/articles/$id", %data );
}

sub destroy_article {
    my ( $self, $id ) = @_;
    $self->request( 'DELETE', "/articles/$id" );
}

#
# Cases
#
sub get_case {
    my ( $self, $id, %extra ) = @_;
    WWW::Desk::Case->new( 
            id => $id,
            desk => $self,
            %extra,
    );
}


1;
