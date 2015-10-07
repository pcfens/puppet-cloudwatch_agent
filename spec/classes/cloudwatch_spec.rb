require 'spec_helper'

describe 'cloudwatch_agent', :type => :class do

  let :facts do
    {
      :concat_basedir => '/dne',
    }
  end

  context 'defaults' do
    it { is_expected.to contain_cloudwatch_agent__params }
    it { is_expected.to contain_package('curl') }
    it { is_expected.to contain_exec('install-awslogs') }
    it { is_expected.to contain_concat('awslogs.conf').with(
      :path => '/var/awslogs/etc/awslogs.conf',
    )}
    it { is_expected.to contain_concat__fragment('general').with(
      :order => '01',
    ) }
    it { is_expected.to contain_service('awslogs').with(
      :ensure => 'running',
      :enable => true,
    )}
  end

  context 'when installing the package' do
    let :params do
      {
        :package_install => true,
      }
    end

    it { is_expected.to contain_package('awslogs').with(
      'ensure' => 'present',
    )}
    it { is_expected.to contain_concat('awslogs.conf').with(
      :path => '/etc/awslogs/awslogs.conf',
    )}

  end

  context 'when creating log resources' do
    let :params do
      {
        :logs => {
          '/var/log/syslog' => {
            'log_stream_name' => 'testing',
          }
        }
      }
    end

    it { is_expected.to contain_cloudwatch_agent__log('/var/log/syslog') }
  end

end
