# == Class: opendkim::params
#
# Encapsulates the default parameter values for the OpenDKIM module.
# OS Support: Debian, Ubuntu
#
# === Parameters
#
# [*syslog*]
#   Set true to enable logging via syslog.
#   Boolean, default is true
#
# [*umask*]
#   Requests a specific permissions mask to be used for file creation. This
#   only really applies to creation of the socket when Socket specifies a
#   UNIX domain socket, and to the PidFile (if any); temporary files are
#   created by the mkstemp(3) function that enforces a specific file mode on
#   creation regardless of the process umask.
#   String, default is '002'
#
# [*oversignheaders*]
#   Specifies a set of header fields that should be included in all
#   signature header lists (the "h=" tag) once more than the number of times
#   they were actually present in the signed message. The set is empty by
#   default. The purpose of this, and especially of listing an absent header
#   field, is to prevent the addition of important fields between the signer
#   and the verifier. Since the verifier would include that header field
#   when performing verification if it had been added by an intermediary,
#   the signed message and the verified message were different and the
#   verification would fail. Note that listing a field name here and not
#   listing it in the SignHeaders list is likely to generate invalid
#   signatures.
#   String, default is 'From'
#
# === Examples
#
#  Not called explicitly; referenced by opendkim init and config modules.
#
# === Authors
#
#  rjpearce https://github.com/rjpearce
#
#
class opendkim::params {
  $syslog = 'yes'
  $syslog_success = false
  $umask  = '002'
  $oversignheaders = 'From'

  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $package = 'opendkim'
      $service = 'opendkim'
      $user    = 'opendkim'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}, fork me baby.")
    }
  }
}
