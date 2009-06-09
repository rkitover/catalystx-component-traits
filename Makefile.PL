use inc::Module::Install;

name     'CatalystX-Component-Traits';
all_from 'lib/CatalystX/Component/Traits.pm';
author   'Rafael Kitover <rkitover@cpan.org>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

