# Class: splunk::linux_forwarder
#
# Modified version of dhogland/splunk (https://github.com/dhogland/splunk). Modified by Will Ferrer and Ethan Brooks of Run the Business LLC
#

class splunk::linux_forwarder {
  File {
      owner => "${splunk::user}",
      group => "${splunk::group}",
  }

  concat { '/opt/splunkforwarder/etc/system/local/inputs.conf':
    mode   => '0600',
    owner  => "${splunk::user}",
    group  => "${splunk::group}",
    notify => Service['splunk'],
  }
  concat::fragment { 'inputs.conf.header':
    target  => '/opt/splunkforwarder/etc/system/local/inputs.conf',
    content => "# This file is managed by Puppet - DO NOT MODIFY\nhost = ${splunk::host}\n",
    order   => 01,
  }
  file { '/opt/splunkforwarder/etc/system/local/limits.conf':
    content => template('splunk/limits.conf.erb'),
    mode   => '0600',
    notify => Service['splunk'],
  }
  file { '/opt/splunkforwarder/etc/system/local/outputs.conf':
    content => template('splunk/outputs.conf.erb'),
    mode   => '0600',
    notify => Service['splunk'],
  }
  file { '/opt/splunkforwarder/etc/system/local/server.conf':
    content => template('splunk/server.conf.erb'),
    mode   => '0600',
    owner  => 'root', # restarting splunk sets owner to root
    group  => 'root', # restarting splunk sets group to root
    notify => Service['splunk'],
  }

  if "${splunk::provider}" == 'yum' {
    package {"splunkforwarder":
      ensure   => "${splunk::splunk_ver}",
      provider => 'yum',
      notify   => Exec['start_splunk'],
    }
  } else {
    file {"${splunk::params::linux_stage_dir}":
      ensure => directory,
    }
    file {"splunk_installer":
      path    => "${splunk::params::linux_stage_dir}/${splunk::params::installer}",
      source  => "${splunk::params::installerfilespath}${splunk::params::installer}",
      require => File["${splunk::params::linux_stage_dir}"],
    }
    package {"splunkforwarder":
      ensure   => installed,
      source   => "${splunk::params::linux_stage_dir}/${splunk::params::installer}",
      provider => $::operatingsystem ? {
        /(?i)(centos|redhat)/   => 'rpm',
        /(?i)(debian|ubuntu)/ => 'dpkg',
      },
      notify   => Exec['start_splunk'],
    }
  }
#  firewall { "100 allow Splunkd":
#    action => "accept",
#    proto  => "tcp",
#    dport  => "${splunk::params::splunkd_port}",
#  }
  exec {"start_splunk":
    creates => "/opt/splunkforwarder/etc/licenses",
    command => "/opt/splunkforwarder/bin/splunk start --accept-license",
    timeout => 0,
  }
  #exec {"set_forwarder_port":
    #unless  => "/bin/grep \"server \= ${splunk::params::logging_server}:${splunk::params::logging_port}\" /opt/splunkforwarder/etc/system/local/outputs.conf",
    #command => "/opt/splunkforwarder/bin/splunk add forward-server ${splunk::params::logging_server}:${splunk::params::logging_port} -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
    ##require => Exec['set_monitor_default'],
    #notify  => Service['splunk'],
  #}
  #exec {"set_monitor_default":
    #unless  => "/bin/grep \"\/var\/log\" /opt/splunkforwarder/etc/apps/search/local/inputs.conf",
    #command => "/opt/splunkforwarder/bin/splunk add monitor \"/var/log/\" -auth ${splunk::params::splunk_admin}:${splunk::params::splunk_admin_pass}",
    #require => Exec['start_splunk','set_boot'],
  #}
  exec {"set_boot":
    creates => "/etc/init.d/splunk",
    command => "/opt/splunkforwarder/bin/splunk enable boot-start",
    require => Exec['start_splunk'],
  }
  file {'/etc/init.d/splunk':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    require => Exec['set_boot']
  }
  service {"splunk":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/init.d/splunk'],
  }
}
