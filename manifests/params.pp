class cloudwatch::params {
    $package_install = false
    $package_ensure  = present
    $service_ensure  = 'running'
    $service_enable  = true
    $region          = 'us-east-1'
    $state_file      = '/var/awslogs/state/agent-state'
    $installer_url   = 'https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py'
}
