#!perl

use Test::More tests => 19;

use SNA::Network;

my $net = SNA::Network->new();
isa_ok($net, 'SNA::Network', 'test network');

# nodes

my $node_a = $net->create_node_at_index(index => 0, name => 'A');
isa_ok($node_a, 'SNA::Network::Node', 'test node A');
is($node_a->index(), 0, 'index created');
is($node_a->{name}, 'A', 'name created');

my $node_b = $net->create_node_at_index(index => 1, name => 'B');
isa_ok($node_b, 'SNA::Network::Node', 'test node B');
is($node_b->index(), 1, 'index created');
is($node_b->{name}, 'B', 'name created');

is(int $net->nodes(), 2, 'nodes created');


# edges

my $edge = $net->create_edge(source_index => 0, target_index => 1, weight => 1);
isa_ok($edge, 'SNA::Network::Edge', 'test edge');
is($edge->source(), $node_a, 'source connected');
is($edge->target(), $node_b, 'target connected');
is($edge->weight(), 1, 'weight created');

is(int $net->edges(), 1, 'edges created');


# network structure

is(int $node_a->edges(), 1, 'node A connected');
is(int $node_a->outgoing_edges(), 1, 'node A direction');
is(int $node_a->incoming_edges(), 0, 'node A direction');

is(int $node_b->edges(), 1, 'node B connected');
is(int $node_b->incoming_edges(), 1, 'node B direction');
is(int $node_b->outgoing_edges(), 0, 'node B direction');

