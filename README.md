# Collectd-Plugins-openQA

A collectd perl plugin for openQA worker systemd unit check

## Debug output will look like this

```
[2018-10-25 01:04:25] perl: Initializing Perl interpreter...
[2018-10-25 01:04:25] openQA
[2018-10-25 01:04:25] Will write: { worker_instances => 10 }
[2018-10-25 01:04:25] Initialization complete, entering read-loop.
[2018-10-25 01:04:25] Dispatching: systemctl is-active --quiet openqa-worker@1
 {
  plugin => "openQA-worker",
  type => "gauge",
  type_instance => "systemd_service_1",
  values => [0],
} 
[2018-10-25 01:04:25] Dispatching: systemctl is-active --quiet openqa-worker@2
 {
  plugin => "openQA-worker",
  type => "gauge",
  type_instance => "systemd_service_2",
  values => [3],

```

* https://collectd.org/documentation/manpages/collectd-perl.5.shtml#writing_your_own_plugins
* http://open.qa
* https://github.com/os-autoinst/openQA/
* https://progress.opensuse.org/issues/41885
* https://apfelboymchen.net/gnu/collectd/collectd-perl.html
