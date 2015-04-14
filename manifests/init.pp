class cloudwatch (
  $package_install = $cloudwatch::params::package_install,
  $package_ensure  = $cloudwatch::params::package_ensure,
  $installer_url   = $cloudwatch::params::installer_url,
  $service_ensure  = $cloudwatch::params::service_ensure,
  $service_enable  = $cloudwatch::params::service_enable,
  $region          = $cloudwatch::params::region,
  $state_file      = $cloudwatch::params::state_file,
  $logs            = {},
) inherits cloudwatch::params {

  validate_string($region, $state_file)
  validate_hash($logs)

  anchor { 'cloudwatch::begin': } ->
  class { 'cloudwatch::package': } ->
  class { 'cloudwatch::config': } ->
  class { 'cloudwatch::service': } ->
  anchor { 'cloudwatch::end': }

  if !empty($logs) {
    create_resources('cloudwatch::log', $logs)
  }

}
