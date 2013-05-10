# Class: splunk::windows_forwarder
#
# Modified version of dhogland/splunk (https://github.com/dhogland/splunk). Modified by Will Ferrer and Ethan Brooks of Run the Business LLC
#
class splunk::windows_forwarder {
  file {"${splunk::params::windows_stage_drive}\\installers":
    ensure => directory;
  }
  file {"splunk_installer":
    path   => "${splunk::params::windows_stage_drive}\\installers\\${splunk::params::installer}", 
    source => "${splunk::params::installerfilespath}${splunk::params::installer}",
  }
  package {"Universal Forwarder":
    source          => "${splunk::params::windows_stage_drive}\\installers\\${splunk::params::installer}",
    install_options => {
      "AGREETOLICENSE"         => 'Yes',
      "RECEIVING_INDEXER"      => "${splunk::params::logging_server}:${splunk::params::logging_port}",
      "LAUNCHSPLUNK"           => "1",
      "SERVICESTARTTYPE"       => "auto",
      "WINEVENTLOG_APP_ENABLE" => "1",
      "WINEVENTLOG_SEC_ENABLE" => "1",
      "WINEVENTLOG_SYS_ENABLE" => "1",
      "WINEVENTLOG_FWD_ENABLE" => "1",
      "WINEVENTLOG_SET_ENABLE" => "1",
      "ENABLEADMON"            => "1",
    },
    require         => File['splunk_installer'],
  }
  service {"SplunkForwarder":
    ensure  => running,
    enable  => true,
    require => Package['Universal Forwarder'],
  }
}
