Facter.add("splunksslkeysfilepassword") do
    setcode do
        Facter::Util::Resolution.exec('bash -c "if [ -f /opt/splunkforwarder/etc/system/local/server.conf ]; then /bin/grep sslKeysfilePassword /opt/splunkforwarder/etc/system/local/server.conf | /usr/bin/cut -d\" \" -f3; fi"')
    end
end 
