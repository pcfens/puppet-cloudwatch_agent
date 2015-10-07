# Class: cloudwatch_agent
#
# This class installs the cloudwatch log shipper and helps manage which
# files are shipped.
#
class cloudwatch_agent (
  $package_install = $cloudwatch_agent::params::package_install,
  $package_ensure  = $cloudwatch_agent::params::package_ensure,
  $installer_url   = $cloudwatch_agent::params::installer_url,
  $service_ensure  = $cloudwatch_agent::params::service_ensure,
  $service_enable  = $cloudwatch_agent::params::service_enable,
  $region          = $cloudwatch_agent::params::region,
  $state_file      = $cloudwatch_agent::params::state_file,
  $logs            = {},
) inherits cloudwatch_agent::params {

  validate_string($region, $state_file)
  validate_hash($logs)

  anchor { 'cloudwatch_agent::begin': } ->
  class { 'cloudwatch_agent::package': } ->
  class { 'cloudwatch_agent::config': } ->
  class { 'cloudwatch_agent::service': } ->
  anchor { 'cloudwatch_agent::end': }

  if !empty($logs) {
    create_resources('cloudwatch_agent::log', $logs)
  }

}
