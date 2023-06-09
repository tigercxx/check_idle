#!/bin/bash

# set the inactivity period (in minutes)
inactivity_period=60

# check if anyone is currently connected via ssh
active_sessions=$(sudo netstat -tnp | grep 'sshd' | grep 'ESTABLISHED')

if [[ -z "$active_sessions" ]]; then
    # no one is currently connected, check when was the last disconnection
    last_disconnection=$(grep 'Removed session' /var/log/auth.log | tail -n 1 | awk '{print $1 " " $2 " " $3}')

    # convert it to seconds since epoch
    last_disconnection_sec=$(date --date="$last_disconnection" +%s)

    # get the current time in seconds since epoch
    current_sec=$(date +%s)

    # calculate the difference in minutes
    diff_min=$(( (current_sec - last_disconnection_sec) / 60 ))

    if (( diff_min > inactivity_period )); then
        # more than an hour has passed since the last ssh session was disconnected
        echo "The server has been idle for more than $inactivity_period minutes. Shutting down."
        sudo shutdown -h now
    else
        echo "The server is idle, but the last session was disconnected less than $inactivity_period minutes ago. Not shutting down."
    fi
else
    echo "There are active ssh sessions. Not shutting down."
fi
