# Check Idle 
This script will shutdown the VM if there are no active ssh sessions. Primarily meant for development machines to turn off idle machines in case developers forget to turn them off.

## Set up
Pick an inactive period you wish to shutdown the VM off.
```
chmod +x check-idle.sh
sudo cp check-idle.sh /usr/local/bin/check_idle.sh

sudo crontab -u root -e
```

Add this line
```
*/5 * * * * /usr/local/bin/check_idle.sh >> /tmp/check_idle_logs.log 2>&1
```
This script will run every 5 minutes, if the last active sessions has been disconnected for X minutes, it will shutdown the machine.

This was tested and used in GCP VMs.
