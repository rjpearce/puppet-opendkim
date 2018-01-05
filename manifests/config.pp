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
# [*internalhosts*]
#   Inherited from params class.
#
# [*additional_parameters*]
#   Hash of parameters to add to opendkim.conf file.
#   Defaults to an empty hash.
#   Example (in yaml for hiera):
#
#   opendkim::config::additional_parameters:
#     DNSTimeout: 25
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
  $syslog_success          = $opendkim::params::syslog_success,
  $umask                   = $opendkim::params::umask,
  $oversignheaders         = $opendkim::params::oversignheaders,
  $internalhosts           = $opendkim::params::internalhosts,
  $additional_parameters   = {},
) inherits ::opendkim::params {

  concat { ['/etc/opendkim.conf', '/etc/default/opendkim', '/etc/opendkim_keytable.conf', '/etc/opendkim_signingtable.conf']:
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Service[$opendkim::params::service],
  }
  concat::fragment {
    'opendkim config header':
      target  => '/etc/opendkim.conf',
      content => "###### MANAGED BY PUPPET\n",
      order   => 01;

    'opendkim config':
      target  => '/etc/opendkim.conf',
      content => template('opendkim/opendkim.conf.erb'),
      order   => 02;

    'opendkim default config header':
      target  => '/etc/default/opendkim',
      content => "###### MANAGED BY PUPPET\n",
      order   => 01;

    'opendkim default config':
      target  => '/etc/default/opendkim',
      content => template('opendkim/opendkim_default.erb'),
      order   => 02;

    'opendkim keytable header':
      target  => '/etc/opendkim_keytable.conf',
      content => "###### MANAGED BY PUPPET\n",
      order   => 01;

    'opendkim signing table header':
      target  => '/etc/opendkim_signingtable.conf',
      content => "###### MANAGED BY PUPPET\n",
      order   => 01;
  }
}
