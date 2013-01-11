# Class: splunk
#
# This class installs and configurs splunk. It is a paramaritized version of dhogland/splunk (https://github.com/dhogland/splunk) and includes some small bug fixes and tweaks as well. Modified by Will Ferrer and Ethan Brooks of Run the Business LLC
#
# Parameters:
#  - $deploy: valid values are server, syslog, (Default: 'server')
#  - $splunk_ver: the username to run the command with (Default: '4.3.1-119532')
#  - $logging_server: not validated, but should be hostname or IP (Default: undef)
#  - $syslogging_port: syslog port (Default: '514')
#  - $logging_port: forwarder port (Default: '8002')
#  - $splunkd_port: splunk d port (Default: '8089')
#  - $admin_port: admin port (Default: '8000')
#  - $splunk_admin: splunk admin name (Default: 'admin')
#  - $splunk_admin_pass: splunk admin password  (Default: 'changeme')
#  - $installerfilespath: path to the installers downloaded for splunk (Default: 'puppet:///modules/${module_name}/')

class splunk (
  $deploy              = 'server', #valid values are server, syslog, forwarder,
  $splunk_ver          = '4.3.1-119532', #TODO: Get newest version to work: '5.0.1-143156'
  $logging_server      = undef, #not validated, but should be hostname or IP
  $syslogging_port     = '514',
  $logging_port        = '8002',
  $splunkd_port        = '8089',
  $admin_port          = '8000',
  $splunk_admin        = "admin",
  $splunk_admin_pass   = "changeme",
  $installerfilespath   = "puppet:///modules/${module_name}/"
) {
  if $logging_server == undef {
    fail('Error: no splunk logging server specified')
  }
  class{"splunk::params":
    deploy               => $deploy, 
	  splunk_ver           => $splunk_ver,
	  logging_server       => $logging_server,
	  syslogging_port      => $syslogging_port,
	  logging_port         => $logging_port,
	  splunkd_port         => $splunkd_port,
	  admin_port           => $admin_port,
	  splunk_admin         => $splunk_admin,
	  splunk_admin_pass    => $splunk_admin_pass,
	  installerfilespath   => $installerfilespath,
  }
  case $::kernel {
    /(?i)linux/: { include "splunk::linux_${splunk::params::deploy}" }
    /(?i)windows/: { 
      if $splunk::params::deploy == 'syslog' { 
        notify {"Err":
          message => "Syslog configuration is not available for ${::kernel} in this module.",
        }
      }
      else { 
        include "splunk::windows_${splunk::params::deploy}" 
        Exec {
          path => "${::path}\;\"C:\\Program Files\\Splunk\\bin\""
        }
      }
    }
  }
}
