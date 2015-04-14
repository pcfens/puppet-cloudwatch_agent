class cloudwatch::config {
  $awslogs_config_dir = '/var/awslogs/etc'

  concat { 'awslogs.conf':
    ensure => present,
    path   => "${awslogs_config_dir}/awslogs.conf",
  }

  concat::fragment { 'general':
    target  => 'awslogs.conf',
    content => template("${module_name}/awslogs.conf.erb"),
    order   => '01',
    notify  => Service['awslogs'],
  }

}
