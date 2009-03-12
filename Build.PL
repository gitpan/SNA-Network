use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SNA::Network',
    license             => 'perl',
    dist_author         => 'Darko Obradovic <dobradovic@gmx.de>',
    dist_version_from   => 'lib/SNA/Network.pm',
    build_requires => {
        'Test::More'              => 0,
        'Module::List::Pluggable' => 0,
    },
    add_to_cleanup      => [ 'SNA-Network-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
