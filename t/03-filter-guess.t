#!perl

use Test::More tests => 8;

use SNA::Network;

my $net = SNA::Network->new();
$net->load_from_gdf('t/test-network-1.gdf');

is(int $net->nodes(), 4, 'nodes read');
is(int $net->edges(), 6, 'edges read');
is($net->node_at_index(3)->{name}, 'D', 'node D read');

my ($edge1) = $net->edges();
is($edge1->{weight}, 1, 'weight loaded');

$net->save_to_gdf(filename => 't/test-network-1b.gdf', edge_fields => ['weight']);

my $net_b = SNA::Network->new();
$net_b->load_from_gdf('t/test-network-1b.gdf');

is(int $net_b->nodes(), 4, 'nodes saved');
is(int $net_b->edges(), 6, 'edges saved');
is($net_b->node_at_index(3)->{name}, 'D', 'node D saved');

my ($edge1_b) = $net_b->edges();
is($edge1_b->{weight}, 1, 'weight saved');

unlink('t/test-network-1b.gdf');

