class opendkim(
  $default_config = true,
  $ensure_version = 'installed'
) inherits ::opendkim::params {

  package { $opendkim::params::package:
    alias  => 'opendkim',
    ensure => $ensure_version
  }
  service { $opendkim::params::service:
    enable  => true,
    require => Package['opendkim'];
  }
  file { '/etc/dkim':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => 0644;
  }
  if ($default_config) {
    include opendkim::config
  }
}
