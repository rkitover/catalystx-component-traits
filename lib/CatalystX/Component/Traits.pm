package CatalystX::Component::Traits;

use namespace::autoclean;
use Moose::Role;
use Moose::Autobox;
use Carp;
use List::MoreUtils 'firstidx';
with 'MooseX::Traits::Pluggable' => { excludes => ['_find_trait'] };

=head1 NAME

CatalystX::Component::Traits - Automatic Trait Loading and Resolution for
Catalyst Components

=head1 VERSION

Version 0.01

=cut

our $VERSION   = '0.01';
our $AUTHORITY = 'id:RKITOVER';

=head1 SYNOPSIS

    package Catalyst::Model::SomeModel;
    with 'CatalystX::Component::Traits';

    package MyApp::Model::MyModel;
    use parent 'Catalyst::Model::SomeModel';

    package MyApp;

    __PACKAGE__->config('Model::MyModel' => {
        traits => ['SearchedForTrait', '+Fully::Qualified::Trait']
    });    

=head1 DESCRIPTION

Adds a L<Catalyst::Component/COMPONENT> method to your L<Catalyst> component
base class that reads the optional C<traits> parameter from app and component
config and instantiates the component subclass with those traits using
L<MooseX::Traits/new_with_traits> from L<MooseX::Traits::Pluggable>.

=head1 TRAIT SEARCH

Trait names qualified with a C<+> are taken to be full package names.

Unqualified names are searched for, using the algorithm described below.

=head2 EXAMPLE

Suppose your inheritance hierarchy is:

    MyApp::Model::MyModel
    MyAppBase::Model::BaseModel
    Catalyst::Model::CatModel
    Catalyst::Model
    Catalyst::Component
    Moose::Object

The configuration is:

    traits => ['Foo']

The package search order for C<Foo> will be:

    MyApp::TraitFor::Model::CatModel::Foo,
    MyAppBase::TraitFor::Model::CatModel::Foo,
    Catalyst::TraitFor::Model::CatModel::Foo,
    Catalyst::TraitFor::Model::Foo,
    Catalyst::TraitFor::Component::Foo,
    MooseX::TraitFor::Object::Foo

=cut

has '_trait_namespace' => (default => '+Trait');

sub COMPONENT {
    my ($class, $app, $args) = @_;

    $args = $class->merge_config_hashes($class->config, $args);

    if (my $traits = delete $args->{traits}) {
	return $class->new_with_traits({
	    traits => $traits,
	    %$args
	});
    }

    return $class->new($args);
}

sub _find_trait {
    my ($class, $base, $name) = @_;

    for my $trait ($class->_trait_search_order($base, $name)) {
        return $trait if eval { Class::MOP::load_class($trait) };
    }

    croak "Could not find a class for trait: $name";
}

sub _trait_search_order {
    my ($class, $base, $name) = @_;

    my @search_ns = $class->meta->class_precedence_list;

    my $parent_idx    = firstidx { /^Catalyst::/ } @search_ns;
    my $parent        = $search_ns[$parent_idx];
    my ($parent_name) = $parent =~ /^Catalyst::(.*)/;

    my @res;

    for my $ns (@search_ns[0 .. $parent_idx]) {
	my ($part) = $ns =~ /^([^:]+)/;
	push @res, "${part}::${base}For::${parent_name}::$name";
	last if $part eq 'Catalyst';
    }
    for my $ns (@search_ns[($parent_idx+1) .. $#search_ns]) {
	my ($part, $rest) = split /::/, $ns, 2;

	# no non-core crap in the Moose:: namespace
	$part = 'MooseX' if $part eq 'Moose';
	
	push @res, "${part}::${base}For::${rest}::$name";
    }

    @res;
}

=head1 AUTHOR

Rafael Kitover, C<< <rkitover at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalystx-component-traits
at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CatalystX-Component-Traits>.  I
will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

More information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CatalystX-Component-Traits>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CatalystX-Component-Traits>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CatalystX-Component-Traits>

=item * Search CPAN

L<http://search.cpan.org/dist/CatalystX-Component-Traits/>

=back

=head1 ACKNOWLEDGEMENTS

Matt S. Trout and Tomas Doran helped me with the current design.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2009, Rafael Kitover

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of CatalystX::Component::Traits
