use strict;
use warnings;
use Test::More tests => 2;

{
    package Catalyst::Model::SomeModel;
    use Moose;
    extends 'Catalyst::Model';
    with 'CatalystX::Component::Traits';

    package My::AppBase::Model::AModel;
    use base 'Catalyst::Model::SomeModel';

    package My::App::Model::AModel;
    use base 'My::AppBase::Model::AModel';
}

ok((my $instance = My::App::Model::AModel->new), 'instance');

is_deeply [$instance->_trait_search_order('Trait', 'Foo')], [
    'My::App::TraitFor::Model::SomeModel::Foo',
    'My::AppBase::TraitFor::Model::SomeModel::Foo',
    'Catalyst::TraitFor::Model::SomeModel::Foo',
    'Catalyst::TraitFor::Model::Foo',
    'Catalyst::TraitFor::Component::Foo',
    'MooseX::TraitFor::Object::Foo'
], 'trait search order';
