class cloudwatch::package {
  if $cloudwatch::package_install {
    package { 'awslogs':
      ensure => $cloudwatch::package_ensure,
    }
  } else {
    if !defined(Package['curl']){
      package { 'curl':
        ensure => present
      }
    }

    file { '/tmp/aws.conf':
      ensure  => present,
      content => template("${module_name}/aws.conf.erb"),
    }

    exec { 'install-awslogs':
      command => 'env && curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py |\
        python - -r us-east-1 -n -c /tmp/aws.conf',
      creates => '/var/awslogs/etc/aws.conf',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }
  }
}
