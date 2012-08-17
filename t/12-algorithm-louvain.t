#!perl

use Test::More tests => 5;

use SNA::Network;

my $net = SNA::Network->new_from_pajek_net('t/community-test-network-1.net');

my $num_communities = $net->identify_communities_with_louvain;

# check expected results

is($num_communities, 4, '4 communities expected');

foreach my $community ($net->communities) {
	ok( int $community->members > 30, "community has more than 30 members" );
}

