define opendkim::domain(
  $private_key,
  $domain=$name,
  $selector='mail',
  $key_folder=$::opendkim::params::key_folder
) {

  file {
    "${key_folder}/${domain}.key":
      owner   => 'root',
      group   => 'opendkim',
      mode    => '0640',
      source  => $private_key,
      require => Package[$::opendkim::params::package]
  }

  concat::fragment { "opendkim KeyTable ${name}":
      target  => '/etc/opendkim/KeyTable',
      content  => "${selector}._domainkey.${domain} ${domain}:${selector}:${key_folder}/${domain}.key\n",
      order   => 10,
      require => File["${key_folder}/${domain}.key"],
      notify  => Service[$opendkim::params::service],
  }

  concat::fragment { "opendkim SigningTable ${name}":
      target  => '/etc/opendkim/SigningTable',
      content  => "${domain} ${selector}._domainkey.${domain}\n",
      order   => 10,
      notify  => Service[$opendkim::params::service],
  }

}
