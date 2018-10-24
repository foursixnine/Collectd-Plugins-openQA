package Collectd::Plugins::openQA;

use strict;
use warnings;
use Collectd qw( :all );
use Data::Dump qw(dump);

=head1 NAME

Collectd::Plugins::openQA - a collectd perl plugin for openQA systemd instances

=cut

=head1 SYNOPSIS
This is a collectd plugin for checking status of openQA worker systemd services.
In your collectd config:
    LoadPlugin perl
    ...
    <Plugin perl>
        BaseName "Collectd::Plugins"
        LoadPlugin openQA
        <Plugin openQA>
                worker_instances 10
        </Plugin>
    </Plugin>
=cut

=head1 DESCRIPTION

Small collectd plugin written as a PoC.

=head1 AUTHOR

Santiago Zarate - L<https://foursixnine.io/>
=cut

# enable autoflush
$| = 1;

# declare the version
our $VERSION = "0.1";
my $_plugin_name = "openQA"; # this is the name you provide to LoadPlugin
my $_collection_name = "openQA-worker"; # this results in the directory where files are stored
my $_type_instance_name = "systemd_service_"; # this will result in the actual rrd database
my $_datatype = 'gauge';
my $configuration;


=head1 read

Read basic information per instance, use C<worker_instances> variable to check for
systemd units that are configured already.

For reference, files are stored in the following directory
C<$BaseDir/rrd/$hostname/$plugin_name/$database_$_type_instance_name.rrd>

=cut

sub read {
	my $vl = { plugin => $_collection_name, type => $_datatype };
    for (my $i=1; $i < $configuration->{worker_instances}+1; $i++){
        my $cmd = 'systemctl is-active --quiet openqa-worker@'.$i; # 0 means everything fine, 3 service is inactive
        $vl->{'values'} = [ `$cmd; echo -n \$?` ]; # 0 means everything fine, 3 service is inactive
        $vl->{'type_instance'} = "$_type_instance_name$i";
        plugin_log(LOG_NOTICE, "Dispatching: $cmd \n ". dump($vl)); # debug
        plugin_dispatch_values ($vl);
    }

	return 1;
}

sub config {
    my ($config) = @{ $_[0]->{children} };
    # we only want worker_instances and we know for now, it's there
    $configuration->{ $config->{key} } = pop @{ $config->{values} };
    plugin_log(LOG_NOTICE, "Will write: ". dump($configuration)); # debug
    return 1;
}


plugin_register (TYPE_READ, $_plugin_name, "read");
plugin_register (TYPE_CONFIG, $_plugin_name, "config");
plugin_log(LOG_INFO, $_plugin_name);
1;
