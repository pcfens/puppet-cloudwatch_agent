define cloudwatch::log (
  $ensure           = 'present',
  $file             = $name,
  $datetime_format  = '%b %d %H:%M:%S',
  $log_group_name   = $name,
  $log_stream_name  = '{instance_id}',
  $buffer_duration  = '5000',
  $initial_position = 'start_of_file',
) {

  concat::fragment { $name:
    ensure  => $ensure,
    target  => 'awslogs.conf',
    content => template("${module_name}/log.erb"),
    order   => '20',
  }
}
