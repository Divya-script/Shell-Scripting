#!/usr/bin/env bash
CHECK_LOGS=/var/log/
#check if USER ID is not root, if he is not root, run that script with root permissions
checking_user () {
  if [ "$UID" == 1000 ]
  then
    echo 'Please run this script with root user'
  fi
}
checking_user
#Just to check if i have logs or not
check_logs () {
  if [[ $(find "$CHECK_LOGS" -name '*.gz') ]];
  then
   echo 'I found the tar.gz archive logs here'
  elif ! [[ $(find "$CHECK_LOGS" -name '*.gz') ]];
  then
    echo "No logs here"
  fi
}
check_logs
