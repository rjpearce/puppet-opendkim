# puppet-opendkim

## Overview

Puppet module to manage OpenDKIM

Currently only supports Debian/Ubuntu, fork me to support more distributions.

* `opendkim` : Main class to install, enable and setup default configuration.
* `opendkim::config` : Class to setup OpenDKIM main configuration files.
* `opendkim::socket` : Definition to add a new Socket to the /etc/default/opendkim config file.
* `opendkim::domain` : Definition to add a new Domain to the /etc/opendkim.conf config file.

Setup your DKIM keys:

    openssl genrsa -out example.com.key 1024
    openssl rsa -in example.com.key -out example.com.pub -pubout -outform PEM
    Move the private key file into your own puppet module

Add your public key to a new TXT record in DNS.

    Choose a Selector for your public key, eg. 'mail'
    Create a TXT record for your domain:
      mail._domainkey.example.com => v=DKIM1; k=rsa; p=[THE_CONTENT_OF_THE_PUBLIC_KEY_FILE]

Typical usage:

    include 'opendkim'

    opendkim::socket { 'listen on loopback on port 8891 - Ubuntu default':
      interface => 'localhost';
    }
    opendkim::domain { 'example.com':
      private_key => 'puppet:///modules/mymodule/example.com.key',
    }

Configuration options for adding a Socket to OpenDKIM:

      opendkim::socket { 'listen on loopback on port 8891 - Ubuntu default':
        interface => 'localhost';
      }

      opendkim::socket { 'listen on a 192.168.1.1 port 8000':
        type      => 'inet',
        interface => '192.168.1.1',
        port      => '8000';
      }

      opendkim::socket { 'listen on a local file socket':
        type => 'file',
      }

      opendkim::socket { 'listen on a local file socket with a custom name':
        type => 'file',
        file => '/var/run/opendkim/my_custom_name.sock';
      }

Configuration options for adding a Domain to OpenDKIM:

    opendkim::domain { 'example.com':
      private_key => 'puppet:///modules/mymodule/example.com.key',
    }

    opendkim::domain { 'example with custom key folder, selector and domain name':
      domain      => 'myexampleduck.com
      private_key => 'puppet:///modules/mymodule/myexampleduck.com.key',
      selector    => 'duck',
      key_folder  => '/etc/duck';
    }

Dependencies:
  concat


