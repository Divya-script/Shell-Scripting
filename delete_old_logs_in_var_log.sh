  
#!/usr/bin/env bash
LOGS=/var/log/
#finding the archive logs and remove it
find_archive_logs () {
  if [ "$UID" == 0 ]; then
    find "$LOGS" -name '*.gz' -exec rm {} \;
    echo 'Your archive logs is deleted'
  fi
  if [ "$UID" == 1000 ]; then #If user id is NOT ROOT,exit
    echo 'Please run that script with root user'
    exit
  fi
}
find_archive_logs
