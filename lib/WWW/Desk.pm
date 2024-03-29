package WWW::Desk;
# ABSTRACT: Query the Desk.com API

use Moo;
use strict; use warnings;
use LWP::UserAgent;
use HTTP::Request;
use Net::OAuth::ProtectedResourceRequest;
use JSON;

use WWW::Desk::Article;
use WWW::Desk::Case;
use WWW::Desk::Customer;
use WWW::Desk::Group;
use WWW::Desk::Macro;
use WWW::Desk::Topic;
use WWW::Desk::User;
#use WWW::Desk::Interaction;

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
use DDP;
sub _make_obj_array {
    my ( $self, $name, $path, $object, %args ) = @_;
    my @raw = @{$self->request( GET => $path, %args )->{results}};
    my @objects;
    for (@raw) {
        push @objects, $object->new(
                id => $$_{$name}{id},
                desk => $self,
                obj => $_,
        );
    }
    \@objects;
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

sub get_topics {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("topic", "/topics", "WWW::Desk::Topic", %args);
}

sub create_topic {
    my ( $self, %data ) = @_;
    $self->request( 'POST', "/topics", %data );
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

sub get_cases {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("case", "/cases", "WWW::Desk::Case", %args);
}

#
# Customers
#
sub get_customer {
    my ( $self, $id ) = @_;
    WWW::Desk::Customer->new( 
            id => $id,
            desk => $self,
    );
}

sub get_customers {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("customer", "/customers", "WWW::Desk::Customer", %args);
}

#
# Groups
#
sub get_group {
    my ( $self, $id ) = @_;
    WWW::Desk::Group->new( 
            id => $id,
            desk => $self,
    );
}

sub get_groups {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("group", "/groups", "WWW::Desk::Group", %args);
}


#
# Macros
#
sub get_macro {
    my ( $self, $id ) = @_;
    WWW::Desk::Macro->new( 
            id => $id,
            desk => $self,
    );
}

sub get_macros {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("macro", "/macros", "WWW::Desk::Macro", %args);
}

sub create_macro {
    my ( $self, %data ) = @_;
    $self->request( 'POST', "/macros", %data );
}

#
# Users
#
sub get_user {
    my ( $self, $id ) = @_;
    WWW::Desk::User->new( 
            id => $id,
            desk => $self,
    );
}

sub get_users {
    my ( $self, %args ) = @_;
    $self->_make_obj_array("user", "/users", "WWW::Desk::User", %args);
}

#
# Interactions
#
#sub get_interaction {
#   my ( $self, $id ) = @_;
#   WWW::Desk::Interaction->new( 
#           id => $id,
#           desk => $self,
#   );
#}

#sub get_interactions {
#   my ( $self, %args ) = @_;
#   $self->_make_obj_array("interaction", "/interactions", "WWW::Desk::Interaction", %args);
#}

=head1 NAME

WWW::Desk - A simple OO interface to the Desk.com API

=head1 SYNOPSIS

  use WWW::Desk;

  my $desk = WWW::Desk->new(
        consumer_key    => "...",
        consumer_secret => "...",
        access_token    => "...",
        access_secret   => "...",
        subdomain       => "$yoursubdomain", # $yoursubdomain.desk.com
  );

  my @topics = $desk->get_topics( 
          count => 20, # defaults
          page  => 1,
  ); # returns an arrayref of WWW::Desk::Topics

  print $_->name."\n" for @topics;


=head1 ABSTRACT

WWW::Desk is an OO interface to the Desk.com OAuth API.

=cut
1;
