require 'spec_helper'

describe 'opendkim::domain', :type => :define do

    let(:name)  { 'example.com' }
    let(:title) { 'example.com' }

    let(:default_params) do
        {
                :private_key_source => 'puppet:///path/to/example.com.key',
        }
    end

    let(:pre_condition) { 'include ::opendkim'}

    describe 'for example.com domain with custom selector' do
        let(:params) do
            default_params.merge( {
                :selector    => 'testselector',
            } )
        end
        it do
            should contain_file('/etc/dkim/testselector-example.com.key').with(
                :source => 'puppet:///path/to/example.com.key',
                :owner  => 'opendkim',
                :group  => 'root',
                :mode   => '0600',
            )
        end
        it do
            should contain_concat__fragment('keytable_example.com').with(
                'target'  => '/etc/opendkim_keytable.conf',
                'content' => %r{^testselector._domainkey.example.com\sexample.com:testselector:/etc/dkim/testselector-example.com.key}m,
            )
        end
        it do
          should contain_concat__fragment('signingtable_example.com').with(
            'target'  => '/etc/opendkim_signingtable.conf',
            'content' => %r{^example.com\stestselector._domainkey.example.com}m,
          )
        end
    end
end

