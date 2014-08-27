require 'spec_helper'

describe 'opendkim', :type => :class do
    let(:facts) { {
        :operatingsystem => 'Ubuntu',
        :concat_basedir  => '/dne'
    } }
    describe 'for OpenDKIM service' do
        it 'should manage /etc/dkim' do
            should contain_file('/etc/dkim').with(
                'ensure'  => 'directory',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644'
            )
        end
        it 'should manage /etc/default/opendkim' do
            should contain_file("/etc/default/opendkim").with(
                'ensure'  => 'present',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644'
            )
        end
    end
end

