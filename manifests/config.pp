# you cannot pass undef to oversignheaders, so use '' to disable
class opendkim::config(
  $syslog                  = $opendkim::params::syslog,
  $umask                   = $opendkim::params::umask,
  $oversignheaders         = $opendkim::params::oversignheaders,
) inherits ::opendkim::params {

  concat { ['/etc/opendkim.conf', '/etc/default/opendkim']:
    owner => root,
    group => root,
    mode  => '0644';
  }
  concat::fragment {
    "opendkim config":
      target => '/etc/opendkim.conf',
      content => template("opendkim/opendkim.conf.erb"),
      order   => 01;

    "opendkim default config":
      target => '/etc/default/opendkim',
      content => template("opendkim/opendkim_default.erb"),
      order   => 01;
  }
}
