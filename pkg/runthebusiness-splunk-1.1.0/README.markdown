splunk

This class installs and configurs splunk. It is a paramaritized version of dhogland/splunk (https://github.com/dhogland/splunk) and includes some small bug fixes, default values added and other tweaks.


Examples:

	class{"splunk":
	  logging_server      => '<logging server>',
	}

Changes from dhogland/splunk
-------

- Made splunk class paramaritized so it can work with out the entriprise console
- Added support for amd64 systems
- Fixed variable name "installer" in windows set ups to reference: ${splunk::params::installer} (untested by probably fixed issues with windows installs)
- Add the installerfilespath option. This allows you to store your installer files in a seperate module or else where on the disk.

Author
-------
dhogland

Modifieing Authors
-------
Will Ferrer, Ethan Brooks


Contributing Authors  
-------
Brendan Murtagh

Licensees
-------
2012 developed under license for Switchsoft LLC http://www.switchsoft.com a "Direct response telephony company" as part of it's "VOIP Call distribution, ROI analysis platform, call recording, and IVR for inbound and outbound sales" and Run the Business Systems LLC a "Technology development investment group" as part of it's "PHP, Javascript rapid application development framework and MySQL analysis tools"

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

