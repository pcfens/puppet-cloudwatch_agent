class cloudwatch_agent::config {

  if $cloudwatch_agent::package_install {
    $awslogs_config_dir = '/etc/awslogs'
  } else {
    $awslogs_config_dir = '/var/awslogs/etc'
  }

  concat { 'awslogs.conf':
    ensure => present,
    path   => "${awslogs_config_dir}/awslogs.conf",
    notify => Service['awslogs'],
  }

  concat::fragment { 'general':
    target  => 'awslogs.conf',
    content => template("${module_name}/awslogs.conf.erb"),
    order   => '01',
  }

}
