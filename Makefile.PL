use inc::Module::Install;

name     'CatalystX-Component-Traits';
all_from 'lib/CatalystX/Component/Traits.pm';
author   'Rafael Kitover <bobtfish@cpan.org>';
license  'perl';

test_requires 'Test::More' => '0.88';

requires 'Catalyst::Runtime'         => '5.80005';
requires 'MooseX::Traits::Pluggable' => '0.08';
requires 'namespace::autoclean';
requires 'List::MoreUtils';
requires 'Scalar::Util';
requires 'Class::Load';

test_requires 'Module::Pluggable' => '3.9';

auto_provides;
auto_install;

resources repository =>
    'git://github.com/bobtfish/catalystx-component-traits.git';

WriteAll;
