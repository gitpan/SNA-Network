package SNA::Network;

use warnings;
use strict;

use Carp;
use English;

use List::Util qw(sum);

use SNA::Network::Node;
use SNA::Network::Edge;
use SNA::Network::Filter::Pajek;
use SNA::Network::Filter::Guess;
use SNA::Network::Algorithm::HITS;


=head1 NAME

SNA::Network - A toolkit for Social Network Analysis

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

    use SNA::Network;

    my $net = SNA::Network->new();
    $net->create_node_at_index(index => 0, name => 'A');
    $net->create_node_at_index(index => 1, name => 'B');
    $net->create_edge(source_index => 0, target_index => 1, weight => 1);
    ...
    
=head1 DESCRIPTION

SNA::Network is a bundle of modules for network algorithms,
specifically designed for the needs of Social Network Analysis (SNA),
but can be used for any other graph algorithms of course.

It represents a standard directed and weighted network,
which can also be used as an undirected and/or unweighted network of course.
It is freely extensible by using own hash entries.

Data structures have been designed for SNA-typical sparse network operations,
and consist of Node and Edge objects, linked via references to each other.

Functionality is implemented in sub-modules in the B<SNA::Network> namespace,
and all methods are imported into B<Network.pm>.
So you can read the documentation in the sub-modules and call the methods
from your B<SNA::Network> instance.

Methods are called with named parameter style, e.g.

	$net->method( param1 => value1, param2 => value2, ...);
	
Only in cases, where methods have only one parameter,
this one is passed by value.

This module was implemented mainly because I had massive problems
understanding the internal structures of Perl's L<Graph> module.
Despite it uses lots of arrays instead of hashes for attributes
and bit setting for properties, it was terribly slow for my purposes.
It has much more features and plugins though.


=head1 METHODS

=head2 new

Creates a new empty network.
There are no parameters.
After creation, use methods to add nodes and edges,
or load a network from a file.

=cut

sub new {
	my ($package) = @_;
	return bless { nodes => [], edges => [] }, $package;
}


=head2 create_node_at_index

Creates a node at the given index.
Pass node attributes as additional named parameters, index is mandatory.
Returns the created L<SNA::Network::Node> object.

=cut

sub create_node_at_index {
	my ($self, %node_attributes) = @_;
	return $self->{nodes}->[$node_attributes{index}] = SNA::Network::Node->new(%node_attributes);
}


=head2 create_edge

Creates a new edge between nodes with the given B<source_index> and B<target_index>.
A B<weight> is optional, it defaults to 1.
Returns the created L<SNA::Network::Edge> object.

=cut

sub create_edge {
	my ($self, %params) = @_;
	my $source_node = $self->node_at_index($params{source_index});
	my $target_node = $self->node_at_index($params{target_index});
	my $edge = SNA::Network::Edge->new( source => $source_node, target => $target_node, weight => $params{weight} || 1);
	push @{ $self->{edges} }, $edge;
	push @{ $source_node->{edges} }, $edge;
	push @{ $target_node->{edges} }, $edge;
	return $edge;
}


=head2 nodes

Returns the array of L<SNA::Network::Node> objects belonging to this network.

=cut

sub nodes {
	my ($self) = @_;
	return @{ $self->{nodes} };
}


=head2 node_at_index

Returns the L<SNA::Network::Node> object at the given index.

=cut

sub node_at_index {
	my ($self, $index) = @_;
	return $self->{nodes}->[$index];
}


=head2 edges

Returns the array of L<SNA::Network::Edge> objects belonging to this network.

=cut

sub edges {
	my ($self) = @_;
	return @{ $self->{edges} };
}


=head2 delete_nodes

Delete the passed node objects.
These have to be sorted by index!
All related edges get deleted as well.
Indexes get restored after this operation.

=cut

sub delete_nodes {
	my ($self, @nodes_to_delete) = @_;
	# nodes have to be sorted by index!
	
	foreach (@nodes_to_delete) {
		$self->delete_edges( $_->edges() );
	}
	
	$self->{nodes} = [ grep {
		($nodes_to_delete[0] && $_ == $nodes_to_delete[0]) ? shift @nodes_to_delete && 0 : 1 
	} $self->nodes() ];
	$self->_restore_indexes();
}


sub _restore_indexes {
	my ($self) = @_;
	my $i = 0;
	foreach ($self->nodes()) {
		$_->{index} = $i++;
		undef $_->{weak_component_index};
	}
}


=head2 delete_edges

Delete the passed edge objects.

=cut

sub delete_edges {
	my ($self, @edges_to_delete) = @_;
	
	foreach my $edge (@edges_to_delete) {
		foreach my $node ( @{$edge}{qw(source target)} ) {
			$_->{edges} = [ grep {
				$_ != $edge
			} @{ $_->{edges} } ]
		}
	}
	
	# somewhat tricky: delete when matched first edge_to_delete and shift it in that case
	$self->{edges} = [ grep {
		($edges_to_delete[0] && $_ == $edges_to_delete[0]) ? shift @edges_to_delete && 0 : 1 
	} $self->edges() ];
}


=head1 SEE ALSO

=over 4

=item * L<SNA::Network::Node>

=item * L<SNA::Network::Edge>

=item * L<SNA::Network::Filter::Pajek>

=item * L<SNA::Network::Filter::Guess>

=item * L<SNA::Network::Algorithm::HITS>

=back


=head1 AUTHOR

Darko Obradovic, C<< <dobradovic at gmx.de> >>


=head1 BUGS

Please report any bugs or feature requests to C<bug-sna-network at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SNA-Network>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SNA::Network


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SNA-Network>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SNA-Network>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SNA-Network>

=item * Search CPAN

L<http://search.cpan.org/dist/SNA-Network>

=back


=head1 ACKNOWLEDGEMENTS

This module has been developed as part of my work at the
German Research Center for Artificial Intelligence (DFKI) L<http://www.dfki.de/>.


=head1 COPYRIGHT & LICENSE

Copyright 2009 Darko Obradovic, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of SNA::Network
