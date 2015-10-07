class cloudwatch_agent::service {
  service { 'awslogs':
    ensure => $cloudwatch_agent::service_ensure,
    enable => $cloudwatch_agent::service_enable,
  }
}
