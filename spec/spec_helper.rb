require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |cfg|
  cfg.default_facts = {
    :concat_basedir => '/var/lib/puppet/concat'
  }
end
