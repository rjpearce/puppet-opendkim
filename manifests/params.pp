class opendkim::params {
  $syslog = 'yes'
  $umask  = '002'
  $oversignheaders = 'From'

  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $package = 'opendkim'
      $service = 'opendkim'
      $key_folder = '/etc/dkim'
      $service_config = '/etc/default/opendkim'
      $service_flavor = 'Debian'
    }
    'Fedora', 'CentOS', 'RedHat': {
      $package = 'opendkim'
      $service = 'opendkim'
      $key_folder = '/etc/opendkim/keys'
      $service_config = '/etc/sysconfig/opendkim'
      $service_flavor = 'Fedora'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}, fork me baby.")
    }
  }
}
