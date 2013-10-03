# Defined Type: splunk::monitor
#
# This defined type manages monitors for Splunk.
#
# Parameters:
#  There are no default parameters for this class. All parameters are managed
#  at declaration time.
#
#  $log: Log file to monitor. File must exist on the Puppet node to be added.
#  $action: The action to perform. Choices are 'add' or 'remove'.
#
# Requires:
#  runthebusiness/splunk
#
# Sample Usage:
#   splunk::monitor { 'production_log':
#     log    => '/var/log/production.log',
#     action => 'add',
# }
define splunk::monitor($log, $action, $order, $whitelist = undef, $blacklist = undef) {

  include splunk

  case $action {
    'add': {
      #exec { "add_${name}":
        #onlyif  => "/usr/bin/test -f ${log}",
        #unless  => "/bin/grep \"${log}\" /opt/splunkforwarder/etc/apps/search/local/inputs.conf",
        #command => "/opt/splunkforwarder/bin/splunk add monitor \"${log}\" -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
        #notify  => Service['splunk'],
      #}
      concat::fragment { "inputs.conf.${order}":
        target  => '/opt/splunkforwarder/etc/system/local/inputs.conf',
        content => template('splunk/monitor.erb'),
        order   => "${order}",
      }
    }
    'remove': {
      exec { "remove_${name}":
        onlyif  => "/usr/bin/test -f ${log} && /bin/grep \"${log}\" /opt/splunkforwarder/etc/apps/search/local/inputs.conf",
        command => "/opt/splunkforwarder/bin/splunk remove monitor \"${log}\" -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
        notify  => Service['splunk'],
      }
    }
    default: {
      fail("${title}: ${name} value '${action}' is not supported.")
    }
  }
}
