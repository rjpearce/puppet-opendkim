class opendkim(
  $default_config = true,
  $ensure_version = 'installed'
) inherits ::opendkim::params {

  package { $opendkim::params::package:
    ensure => $ensure_version,
    alias  => 'opendkim'
  }
  service { $opendkim::params::service:
    ensure  => running,
    enable  => true,
    require => [
      Package['opendkim'],
      Class['opendkim::config'],
    ]
  }
  file { '/etc/dkim':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }
  if ($default_config) {
    include opendkim::config
  }
}
