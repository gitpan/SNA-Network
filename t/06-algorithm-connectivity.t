#!perl

use Test::More tests => 1;

use SNA::Network;

my $net = SNA::Network->new();
$net->load_from_pajek_net('t/test-network-2.net');

my $num_weak_components = $net->identify_weak_components();

is($num_weak_components, 3, 'test-network-2 has 3 weak components');

