class cloudwatch_agent::package {
  if $cloudwatch_agent::package_install {
    package { 'awslogs':
      ensure => $cloudwatch_agent::package_ensure,
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
      command => "env && curl ${cloudwatch_agent::installer_url} |\
        python - -r ${cloudwatch_agent::region} -n -c /tmp/aws.conf",
      creates => '/var/awslogs/etc/aws.conf',
      cwd     => '/tmp',
      path    => ['/usr/bin', '/usr/local/sbin', '/usr/sbin', '/sbin', '/bin'],
      require => [Package['curl'], File['/tmp/aws.conf'] ],
    }
  }
}
