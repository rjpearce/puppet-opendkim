# == Class: opendkim::config
#
# Manage OpenDKIM configuration
#
# === Parameters
#
# [*syslog*]
#   Inherited from params class.
#
# [*umask*]
#   Inherited from params class.
#
# [*oversignheaders*]
#   Inherited from params class.
#
# === Examples
#
#   See opendkim init for complete example.
#
# === Authors
#
#  rjpearce https://github.com/rjpearce
#


class opendkim::config(
  $syslog                  = $opendkim::params::syslog,
  $umask                   = $opendkim::params::umask,
  $oversignheaders         = $opendkim::params::oversignheaders,
) inherits ::opendkim::params {

  concat { ['/etc/opendkim.conf', '/etc/default/opendkim']:
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Service[$opendkim::params::service];
  }
  concat::fragment {
    'opendkim config':
      target  => '/etc/opendkim.conf',
      content => template('opendkim/opendkim.conf.erb'),
      order   => 01;

    'opendkim default config':
      target  => '/etc/default/opendkim',
      content => template('opendkim/opendkim_default.erb'),
      order   => 01;
  }
}
