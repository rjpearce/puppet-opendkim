define opendkim::domain(
  $private_key,
  $domain      = $name,
  $selector    = 'mail',
  $key_folder  = '/etc/dkim',
  $signing_key = $name,
  $user        = $opendkim::params::user,
) {
  $key_file = "${key_folder}/$selector-${domain}.key"

  file { $key_file:
      owner  => $user,
      group  => 'root',
      mode   => 0600,
      source => $private_key;
  }

  # Add keytable and signing table to config, but only once
  if( ! defined( Concat::Fragment['opendkim_domain_config'] ) ) {
    concat::fragment{ 'opendkim_domain_config':
      target  => '/etc/opendkim.conf',
      content => "Keytable /etc/opendkim_keytable.conf\nSigningTable /etc/opendkim_signingtable.conf\n\n",
      notify  => Service[$opendkim::params::service];
    }
  }

  concat::fragment{ "signingtable_${name}":
    target  => '/etc/opendkim_signingtable.conf',
    content => "${signing_key} ${selector}._domainkey.${domain}\n",
    order   => 10,
    require => File[$key_file],
    notify  => Service[$opendkim::params::service];
  }
  concat::fragment{ "keytable_${name}":
    target  => '/etc/opendkim_keytable.conf',
    content => "${selector}._domainkey.${domain} ${domain}:${selector}:$key_file\n",
    order   => 10,
    require => File[$key_file],
    notify  => Service[$opendkim::params::service];
  }

}

