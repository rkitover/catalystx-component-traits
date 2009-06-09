package CatalystX::Component::Traits;

use strict;
use warnings;

=head1 NAME

CatalystX::Component::Traits - Automatic Trait Loading and Resolution for
Catalyst Components

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    package Catalyst::Model::SomeModel;
    with 'CatalystX::Component::Traits';

    package MyApp::Model::MyModel;
    use parent 'Catalyst::Model::SomeModel';

    package MyApp;

    __PACKAGE__->config('Model::MyModel' => {
        traits => ['SearchedForTrait', '+Fully::Qualified::Trait']
    });    

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

Matt S. Trout came up with the current design

=head1 COPYRIGHT & LICENSE

Copyright (c) 2009, Rafael Kitover

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of CatalystX::Component::Traits
