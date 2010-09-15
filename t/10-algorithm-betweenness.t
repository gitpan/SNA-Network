#!perl

use Test::More tests => 4;

use SNA::Network;

my $net = SNA::Network->new();
$net->load_from_pajek_net('t/test-network-4.net');

$net->calculate_betweenness();

# check betweenness values

is($net->node_at_index(0)->{betweenness}, 0,     'A has betweenness 0.0');
is($net->node_at_index(1)->{betweenness}, 0.5/6, 'B has betweenness 0.083');
is($net->node_at_index(2)->{betweenness}, 0.5/6, 'C has betweenness 0.083');
is($net->node_at_index(3)->{betweenness}, 0,     'D has betweenness 0.0');

