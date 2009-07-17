use strict;
use warnings;
use Test::More tests => 6;
use Catalyst::Utils;

{
    package Catalyst::Controller::SomeController;
    use Moose;
    extends 'Catalyst::Controller';
    with 'CatalystX::Component::Traits';

    package Catalyst::TraitFor::Controller::SomeController::Foo;
    use Moose::Role;
    has 'foo' => (is => 'ro');

    package MyApp::Controller::MyController;
    use base 'Catalyst::Controller::SomeController';
    use Scalar::Util qw/blessed/;

    __PACKAGE__->config(
        traits => ['Foo', 'Bar'],
        foo => 'bar'
    );

    sub find_app_class {
        my $self = shift;
        blessed($self->_application) || $self->_application;
    }

    package MyApp::TraitFor::Controller::SomeController::Bar;
    use Moose::Role;
    has 'bar' => (is => 'ro');

    package MyApp;
    use Moose;

    extends 'Catalyst';
}

my $app_class = 'MyApp';
ok((my $instance = MyApp::Controller::MyController->COMPONENT(
        $app_class,
        { bar => 'baz' }
    )),
    'created a component instance');

ok(($instance->does('Catalyst::TraitFor::Controller::SomeController::Foo')),
    'instance had parent ns trait loaded from component config');

ok(($instance->does('MyApp::TraitFor::Controller::SomeController::Bar')),
    'instance had app ns trait loaded from component config');

is $instance->foo, 'bar',
    'trait initialized from component config works';

is $instance->bar, 'baz',
    'trait initialized from app config works';

is $instance->find_app_class, 'MyApp', 'Can find app class passing instance';

