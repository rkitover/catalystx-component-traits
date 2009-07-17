use strict;
use warnings;
use Test::More tests => 6;
use Catalyst::Utils;

{
    package Catalyst::Controller::SomeModel;
    use Moose;
    extends 'Catalyst::Controller';
    with 'CatalystX::Component::Traits';

    package Catalyst::TraitFor::Controller::SomeModel::Foo;
    use Moose::Role;
    has 'foo' => (is => 'ro');

    package MyApp::Controller::MyModel;
    use base 'Catalyst::Controller::SomeModel';
    use Scalar::Util qw/blessed/;

    __PACKAGE__->config(
        traits => ['Foo', 'Bar'],
        foo => 'bar'
    );

    sub find_app_class {
        my $self = shift;
        blessed($self->_application) || $self->_application;
    }

    package MyApp::TraitFor::Controller::SomeModel::Bar;
    use Moose::Role;
    has 'bar' => (is => 'ro');
}

my $app_class = 'MyApp';

ok((my $instance = MyApp::Controller::MyModel->COMPONENT(
        $app_class,
        { bar => 'baz' }
    )),
    'created a component instance');

ok(($instance->does('Catalyst::TraitFor::Controller::SomeModel::Foo')),
    'instance had parent ns trait loaded from component config');

ok(($instance->does('MyApp::TraitFor::Controller::SomeModel::Bar')),
    'instance had app ns trait loaded from component config');

is $instance->foo, 'bar',
    'trait initialized from component config works';

is $instance->bar, 'baz',
    'trait initialized from app config works';

TODO: {
    local $TODO = "Finding by class name can't work as we're now an anon class...";
    is $instance->find_app_class, 'MyApp', 'Can find app class passing instance';
}

