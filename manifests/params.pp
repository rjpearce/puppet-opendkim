class opendkim::params {
  $syslog = 'yes'
  $umask  = '002'
  $oversignheaders = 'From'

  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $package = 'opendkim'
      $service = 'opendkim'
    }
    'Fedora', 'CentOS', 'RedHat': {
      $package = 'opendkim'
      $service = 'opendkim'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}, fork me baby.")
    }
  }
}
