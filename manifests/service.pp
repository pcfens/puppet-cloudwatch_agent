class cloudwatch::service {
  service { 'awslogs':
    ensure => $cloudwatch::service_ensure,
    enable => $cloudwatch::service_enable,
  }
}
