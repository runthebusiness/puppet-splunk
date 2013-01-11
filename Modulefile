name 'runthebusiness-splunk'
version '1.0.0'

author 'dhogland, modifieing authors: Will Ferrer and Ethan Brooks (Run the Business)'
license 'Apache License, Version 2.0'
project_page 'https://github.com/runthebusiness/puppet-splunk'
source ''
summary 'This class installs and configurs splunk. It is a paramaritized version of dhogland/splunk (https://github.com/dhogland/splunk) and includes some small bug fixes, default values added and other tweaks.
'
description 'splunk

This class installs and configurs splunk. It is a paramaritized version of dhogland/splunk (https://github.com/dhogland/splunk) and includes some small bug fixes, default values added and other tweaks.


Examples:

	class{"splunk":
	  logging_server      => \'<logging server>\',
	}

Changes from dhogland/splunk
-------
1) Made splunk class paramaritized so it can work with out the entriprise console
2) Added support for amd64 systems
3) Fixed variable name "installer" in windows set ups to reference: ${splunk::params::installer} (untested by probably fixed issues with windows installs)
4) Add the installerfilespath option. This allows you to store your installer files in a seperate module or else where on the disk.

Author
-------
dhogland

Modifieing Authors
-------
Will Ferrer, Ethan Brooks

Licensees
-------
2012 developed under license for Switchsoft LLC http://www.switchsoft.com a "Direct response telephony company" as part of it\'s "VOIP Call distribution, ROI analysis platform, call recording, and IVR for inbound and outbound sales" and Run the Business Systems LLC a "Technology development investment group" as part of it\'s "PHP, Javascript rapid application development framework and MySQL analysis tools"

License
-------
Licensed under the terms of the Apache License, Version 2.0


Contact
-------
will.ferrer@runthebusiness.net

Support
-------

Please send tickets and issues to our contact email address or at: https://github.com/runthebusiness/puppet-splunk/issues

Project Url
-------
https://github.com/runthebusiness/puppet-splunk

'
dependency 'puppetlabs/firewall', '>=0.0.4'