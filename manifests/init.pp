# Class: splunk
#
# This class installs and configurs splunk. It is a paramaritized version of dhogland/splunk (https://github.com/dhogland/splunk) and includes some small bug fixes and tweaks as well. Modified by Will Ferrer and Ethan Brooks of Run the Business LLC
#
# Parameters:
#  - $deploy: valid values are server, syslog, (Default: 'server')
#  - $splunk_ver: the version of software to install (Default: '4.3.1-119532')
#  - $user: the user that should own managed files (Default: 'splunk')  *** Linux only ***
#  - $group: the group of managed files (Default: 'splunk')             *** Linux only ***
#  - $logging_server: not validated, but should be hostname or IP (Default: undef)
#  - $syslogging_port: syslog port (Default: '514')
#  - $logging_port: forwarder port (Default: '8002')
#  - $splunkd_port: splunk d port (Default: '8089')
#  - $admin_port: admin port (Default: '8000')
#  - $splunk_admin: splunk admin name (Default: 'admin')
#  - $splunk_admin_pass: splunk admin password  (Default: 'changeme')
#  - $installerfilespath: path to the installers downloaded for splunk (Default: 'puppet:///modules/${module_name}/')
#  - $provider: package provider to permit yum override (Default: is OS specific)
#  - $host: host value for inputs.conf (Default: $decideOnStartup)
#  - $defaultGroup: defaultGroup value for outputs.conf (Default: default-autolb-group)
#  - $maxKBps: maxKBps value for limits.conf (Default: 0 which is for unthrottled throughput)

class splunk (
  $deploy              = 'server', #valid values are server, syslog, forwarder,
  $splunk_ver          = '5.0.3-163460',
  $user                = 'splunk',
  $group               = 'splunk',
  $logging_server      = undef, #not validated, but should be hostname or IP
  $syslogging_port     = '514',
  $logging_port        = '8002',
  $splunkd_port        = '8089',
  $admin_port          = '8000',
  $splunk_admin        = "admin",
  $splunk_admin_pass   = "changeme",
  $installerfilespath  = "puppet:///modules/${module_name}/",
  $provider            = nil,
  $host                = '$decideOnStartup',
  $defaultGroup        = 'default-autolb-group',
  $maxKBps             = 0,
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
