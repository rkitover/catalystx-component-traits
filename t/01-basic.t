#!perl

use strict;
use warnings;
use Test::More tests => 4;

{
    package Catalyst::Model::SomeModel;
    use Moose;
    extends 'Catalyst::Model';
    with 'CatalystX::Component::Traits';

    package Catalyst::Model::SomeModel::Trait::Foo;
    use Moose::Role;
    has 'foo' => (is => 'ro');

    package Catalyst::Model::SomeModel::Trait::Bar;
    use Moose::Role;
    has 'bar' => (is => 'ro');

    package MyApp::Model::MyModel;
    use base 'Catalyst::Model::SomeModel';

    __PACKAGE__->config(
        traits => ['Foo', 'Bar'],
        foo => 'bar'
    );
}

my $app_class = 'MyApp';

ok((my $instance = MyApp::Model::MyModel->COMPONENT(
        $app_class,
        { bar => 'baz' }
    )),
    'created a component instance');

ok(($instance->does('Catalyst::Model::SomeModel::Trait::Foo')),
    'instance had trait loaded from component config');

is $instance->foo, 'bar',
    'trait initialized from component config works';

is $instance->bar, 'baz',
    'trait initialized from app config works';
