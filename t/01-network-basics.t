#!perl

use Test::More tests => 33;
use Test::Memory::Cycle;

use SNA::Network;
use List::Util qw(sum);


use Devel::Cycle;
use Devel::Peek;

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

# degrees
is($node_a->in_degree, 0, 'node A indegree');
is($node_a->out_degree, 1, 'node A outdegree');
is($node_a->summed_degree, 1, 'node A summed degree');
is($node_b->in_degree, 1, 'node B indegree');
is($node_b->out_degree, 0, 'node B outdegree');
is($node_b->summed_degree, 1, 'node B summed degree');



# deleting nodes
my $net2 = SNA::Network->new();
$net2->load_from_pajek_net('t/test-network-2.net');
$net2->delete_nodes($net2->node_at_index(2), $net2->node_at_index(4));
memory_cycle_ok($net2, "net contains memory cycles");

is(int $net2->nodes(), 5, '5 nodes left');
is(int $net2->edges(), 2, '2 edges left');

	
# deleting edges in any arbitrary order
my $net3 = SNA::Network->new();
$net3->load_from_pajek_net('t/test-network-2.net');
is(int $net3->node_at_index(2)->edges, 4, '4 edges at node C');
$net3->delete_edges( @{$net3->{edges}}[3,2,1] );
is(int $net3->nodes(), 7, '7 nodes left');
is(int $net3->edges(), 4, '4 edges left');
is(int $net3->node_at_index(2)->edges, 1, '1 edge left at node C');
is(sum( map { int $_->edges } $net3->nodes), 8, 'nodes contain 8 edge endpoints');


