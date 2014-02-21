class opendkim::params {
  $syslog = 'yes'
  $umask  = '002'
  $oversignheaders = 'From'

  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $package = 'opendkim'
      $service = 'opendkim'
      $key_folder = '/etc/dkim'
    }
    'Fedora', 'CentOS', 'RedHat': {
      $package = 'opendkim'
      $service = 'opendkim'
      $key_folder = '/etc/opendkim/keys'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}, fork me baby.")
    }
  }
}
