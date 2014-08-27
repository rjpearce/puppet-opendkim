require 'spec_helper'

describe 'opendkim::domain', :type => :define do

    let(:name)  { 'example.com' }
    let(:title) { 'example.com' }

    let(:default_params) do
        {
                :private_key => 'puppet:///path/to/example.com.key',
        }
    end

    describe 'for example.com domain config' do
        let(:params) do
            default_params.merge( {
                #:private_key => 'puppet:///path/to/example.com.key',
                :selector    => 'testselector'
            } )
        end
        it do
            should contain_file('/etc/dkim/example.com.key').with(
                :source => 'puppet:///path/to/example.com.key',
                :owner  => 'root',
                :group  => 'root',
                :mode   => '0640'
            )
        end
        it do
            should contain_concat__fragment('example.com').with(
                'target'  => '/etc/opendkim.conf',
                'content' => %r{^Domain\sexample.com[^#]*KeyFile\s/etc/dkim/example.com.key[^#]*Selector\stestselector}m
                #'content' => %r{^Domain\sexample.com}
            )
        end
    end
end

