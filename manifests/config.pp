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
# [*create_sockets*]
#   hash to create sockets (using define opendkim::socket)
#   Example (iny yaml for hiera):
#
#   opendkim::config::create_sockets:
#     localport:
#       type: 'inet'
#       interface: 127.0.0.1
#       port: 60003
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
  $create_sockets          = {},
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

  create_resources('::opendkim::socket', $create_sockets)
}
