# == Class: opendkim
#
# Manage OpenDKIM.
# Main class to install, enable and setup default configuration.
# OS Support: Debian, Ubuntu
#
# === Parameters
#
# [*default_config*]
#   Set true to use the default configuration specified in opendkim::config.
#   Boolean, default is true.
#
# [*ensure_version*]
#   State of the opendkim package. Valid values are present (also called
#   installed), absent, purged, held, latest. Default is installed.
#
# === Examples
#
#  opendkim::domain { 'example.com':
#      private_key => 'puppet:///modules/mymodule/example.com.key',
#  }
#
#   See opendkim init for complete example.
#
# === Authors
#
#  rjpearce https://github.com/rjpearce
#

define opendkim::domain(
  $private_key,
  $domain=$name,
  $selector='mail',
  $key_folder='/etc/dkim'
) {

  file {
    "${key_folder}/${domain}.key":
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
      source => $private_key;
  }
  concat::fragment{ $name:
    target  => '/etc/opendkim.conf',
    content => "Domain ${domain}\nKeyFile ${key_folder}/${domain}.key\nSelector ${selector}\n\n",
    order   => 10,
    require => File["${key_folder}/${domain}.key"];
  }
}

