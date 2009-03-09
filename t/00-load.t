#!perl -T

use Test::More tests => 6;

BEGIN {
	use_ok( 'SNA::Network' );
	use_ok( 'SNA::Network::Node' );
	use_ok( 'SNA::Network::Edge' );
	use_ok( 'SNA::Network::Filter::Pajek' );
	use_ok( 'SNA::Network::Filter::Guess' );
	use_ok( 'SNA::Network::Algorithm::HITS' );
}

diag( "Testing SNA::Network $SNA::Network::VERSION, Perl $], $^X" );
