# cloudwatch_agent

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with cloudwatch_agent](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cloudwatch_agent](#beginning-with-cloudwatch_agent)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Module Description

The cloudwatch_agent module installs configures and manages the AWS
[Cloudwatch Logs Agent](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/EC2NewInstanceCWL.html).

## Setup

### Setup requirements

Cloudwatch is an AWS service for collecting metrics and log data from AWS Instances.
This module is only usable inside of AWS, and not on instances that run outside of
AWS.

EC2 instances need to have an IAM role to be able to send logs to AWS. Setting up
IAM oles is outside the scope of this document, but there's a nice tutorial that
starts in step 2 in the (Cloudwatch Logs Agent docs)[http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/EC2NewInstanceCWL.html] (step 19 is different if you're using puppet).


### Beginning with cloudwatch_agent

If you want to install the logs agent, and are in the us-east-1 region, you can run
`include ::cloudwatch_agent`. By default, the agent is installed using the python installer
but it can be overridden (to use a package), though the default install doesn't monitor
any logs.

Non us-east-1 regions can be used via the `region` parameter:
~~~
class { 'cloudwatch_agent':
  region => 'us-west-1',
}
~~~

## Usage

Cloudwatch needs a little bit of information about each log file (like date format)
so that it can be parsed out and grouped in a meaningful way by AWS.

After setting up the logs agent, logs can be specified using the `cloudwatch_agent::log`
defined type. Sending `/var/log/syslog` would look like (all parameters are defaults):

~~~
cloudwatch_agent::log { '/var/log/syslog':
  datetime_format  => '%b %d %H:%M:%S',
  log_stream_name  => '{instance_id}',
  buffer_duration  => '5000',
  initial_position => 'start_of_file',
}
~~~

## Reference

### Classes

#### Public Classes

* [`cloudwatch_agent`](#cloudwatch_agent): Installs the cloudwatch log agent

#### Private Classes

* [`cloudwatch_agent::config`](#cloudwatch_agent_config): Sets the awslogs service configuration
* [`cloudwatch_agent::package`](#cloudwatch_agent_package): Install the agent package
* [`cloudwatch_agent::service`](#cloudwatch_agent_service): Manage the awslogs service

### Parameters

#### cloudwatch_agent

##### `package_install`

Specify whether the awslogs package should be used or not, Valid values are 'true', 'false'. Defaults to 'false'.

##### `package_ensure`

The ensure parameter that is passed to the awslogs package resource. Defaults to present.

##### `installer_url`

The URL where the installer should be fetched from. Defaults to https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py.

##### `service_ensure`

The ensure parameter that is passed to the awslogs service resource. Defaults to running.

##### `service_enable`

The enable parameter that is passed to the awslogs service resource. Defaults to true.

##### `region`

The AWS region that the you're running in. Defaults to 'us-east-1'.

##### `state_file`

Where the agent should store its state. Defaults to `/var/awslogs/state/agent-state`

##### `logs`

A hash of `::cloudwatch_agent::log` resources that should be created.

### Defines

#### cloudwatch_agent::log

Full details on what the cloudwatch agent does with these parameters
is available in the [agent reference](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/AgentReference.html) (not all parameters are supported by this module yet).

##### `ensure`

Ensure whether or not the log file should be managed or not. Valid values
are `present` and `absent`. Defaults to `present`.

##### `file`

The file that should be managed. This defaults to the resource name.

##### `datetime_format`

The format of the datetime stamp in the file. Defaults to '%b %d %H:%M:%S'.

##### `log_group_name`

The log group that this file should be grouped with. Defaults to the resource name.

##### `log_stream_name`

The name of the log stream. Defaults to '{instance_id}'.

##### `buffer_duration`

How long log files should be buffered before sending, in milliseconds. Defaults to '5000'.

##### `initial_position`

Where the file should be read to start with, when there's no state file to reference. Defaults to 'start_of_file'.

## Limitations

This module is only useful in AWS, on Linux instances.
