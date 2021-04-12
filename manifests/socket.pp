# == Class: opendkim::socket
#
# Configuration options for adding a Socket to OpenDKIM
#
# === Parameters
#
# [*type*]
#   Your MTA and your opendkim filter will communicate over a socket
#   connection. Set type to 'inet' for a TCP network socket or to
#   'file' for a UNIX filesystem socket.
#   They each have advantages: A UNIX socket can be secured using the
#   filesystem (i.e., with user or group permissions), but cannot be
#   reached from other machines that might want to share the service.
#   String, default is 'inet'
#
# [*file*]
#   When using a UNIX filesystem socket, you can set a custom name here.
#   String, default is '/var/run/opendkim/opendkim.sock'
#
# [*interface*]
#   When using inet sockets, you can specify an interface to which the
#   OpenDKIM socket should bind. If you only want to bind to localhost,
#   set interface to 'localhost'. If you leave the default of false,
#   OpenDKIM will bind to all available interfaces at the port number
#   given below.
#   String if custom interface, default is false for all interfaces.
#
# [*port*]
#   When using inet sockets, you can specify a custom port to which the
#   OpenDKIM socket should bind.
#   Integer, default is 8891
#
# === Examples
#
#   opendkim::socket { 'listen on loopback on port 8891 - Ubuntu default':
#       interface => 'localhost';
#   }
#
#   See opendkim init for complete example.
#
# === Authors
#
#  rjpearce https://github.com/rjpearce
#
#
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
    target  => '/etc/default/opendkim',
    content => "SOCKET=${socket} # ${title}\n",
    order   => "10 ${title}";
  }
}

