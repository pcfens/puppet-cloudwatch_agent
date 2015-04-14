require 'spec_helper'

describe 'cloudwatch::log', :type => :define do

  let :facts do
    {
      :concat_basedir => '/dne',
    }
  end

  let :title do
    '/var/log/syslog'
  end

  context 'with no parameters' do
    it { is_expected.to contain_concat__fragment('/var/log/syslog').with(
      :target => 'awslogs.conf',
      :ensure => 'present',
    )}
  end

end
