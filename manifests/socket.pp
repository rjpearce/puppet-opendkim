define opendkim::socket(
  $type='inet',
  $file='/var/run/opendkim/opendkim.sock',
  $interface=false,
  $port=8891
) {

  case $type {
    'inet': {
      $socket = $interface ? {
        false   => "${type}:${port}",
        default => "${type}:${port}@${interface}",
      }
    }
    'file': {
      $socket = "${type}:${file}"
    }
    default: {
      fail("Unsupported type: ${type}\n")
    }
  }
  concat::fragment{ $socket:
    target  => '/etc/opendkim.conf',
    content => "Socket ${socket} # ${name}\n",
    order   => 10,
    notify  => Service[$opendkim::params::service];
  }
}

