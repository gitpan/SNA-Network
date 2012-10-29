package SNA::Network::Community;

use strict;
use warnings;

use Carp;
use List::Util qw(sum);

use Object::Tiny::XS qw(members_ref index w_in w_tot);


=head1 NAME

SNA::Network::Community - Community class for SNA::Network


=head1 SYNOPSIS

    foreach my $community ($net->communities) {
    	print int $community->members;
    	...
    }
    ...
    ...


=head1 METHODS

=head2 new

Creates a new community with the given named parameters.
Not intended for external use.

=cut

sub new {
	my ($package, %params) = @_;
	croak 'no index passed' unless defined $params{index};
	croak 'no members_ref passed' unless $params{members_ref};	
	my $self = bless { %params }, $package;
	return $self;
}


=head2 index

Returns the index number of this community.
All communities are sequentially numbered starting with 0.


=head2 members

Returns a list of L<SNA::Network::Node> objects, which are members of this community.

=cut

sub members {
	my ($self) = @_;
	return @{ $self->members_ref };
}


=head2 members_ref

Returns the reference to the list of L<SNA::Network::Node> objects, which are members of this community.


=head2 w_in

Returns the sum of all edge weights between community nodes


=head2 w_tot

Returns the sum of all community node's summed degrees.


=head1 AUTHOR

Darko Obradovic, C<< <dobradovic at gmx.de> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-sna-network-node at rt.cpan.org>, or through
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


=head1 COPYRIGHT & LICENSE

Copyright 2012 Darko Obradovic, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;

