require 'spec_helper'

describe 'opendkim::socket', :type => :define do

    #let(:name) { 'example.com' }
    let(:title) { 'inet:8891@localhost' }

    let(:default_params) do
        { }
    end

    context 'for default socket config on localhost port 8891' do
        let(:params) do
            default_params.merge( {
                :interface => 'localhost'
            } )
        end
        it do
            should contain_concat__fragment('inet:8891@localhost').with(
                'target'  => '/etc/default/opendkim',
                'content' => %r{SOCKET\s?=\s?inet:8891@localhost}
            )
        end
    end

    context 'for socket config on dkim.example.com and port 54321' do
        let(:params) do
            default_params.merge( {
                :interface   => 'dkim.example.com',
                :port        => '54321'
            } )
        end
        it do
            should contain_concat__fragment('inet:54321@dkim.example.com').with(
                'target'  => '/etc/default/opendkim',
                'content' => %r{SOCKET\s?=\s?inet:54321@dkim.example.com}
            )
        end
    end
end

