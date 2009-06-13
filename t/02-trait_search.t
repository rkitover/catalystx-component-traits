use strict;
use warnings;
use Test::More tests => 2;

{
    package Catalyst::Model::SomeModel;
    use Moose;
    extends 'Catalyst::Model';
    with 'CatalystX::Component::Traits';

    package MyAppBase::Model::AModel;
    use base 'Catalyst::Model::SomeModel';

    package MyApp::Model::AModel;
    use base 'MyAppBase::Model::AModel';
}

ok((my $instance = MyApp::Model::AModel->new), 'instance');

is_deeply [$instance->_trait_search_order('Trait', 'Foo')], [
    'MyApp::TraitFor::Model::SomeModel::Foo',
    'MyAppBase::TraitFor::Model::SomeModel::Foo',
    'Catalyst::TraitFor::Model::SomeModel::Foo',
    'Catalyst::TraitFor::Model::Foo',
    'Catalyst::TraitFor::Component::Foo',
    'MooseX::TraitFor::Object::Foo'
], 'trait search order';
