#!/bin/bash
#This script reset pwd in aix servers

host=$1

#+++++++++++++++sub Functions+++++++++++++++++++++++++
u_name_chk()
{
ssh -q $host 'uname'
if [[ $? -ne 0 ]]
then
echo "can not access the server"
exit 1ssh
fi
}
pwd_reset_aix()
{
read -p "enter username: " user
sudo ssh -q $host <<EOSSH
grep $user /etc/passwd
if [[ $? -eq 0 ]]
then
read -p 'please enter password:' pass
echo \"${user}:${pass}\" | sudo /usr/bin/chpasswd -c
sudo /usr/bin/pwdadm -c ${user}
lsuser -a unsuccessful_login_count $user
chuser unsuccessful_login_count=0 $user
else
echo "$user not exist in $host"
fi
}
EOSSH

pwd_reset_lx()
{
sudo ssh -q $host <<EOSSH
read -p "enter username: " user
grep $user /etc/passwd
if [[ $? -eq 0 ]]
then
read -p 'please enter password:' pass
echo "$pass" | passwd --stdin $user
EOSSH
}
#+++++++++++++main function ++++++++++++++++++++++++++++++++++
os=$(u_name_chk)
case "$os" in
AIX) pwd_reset_aix
;;
Linux) pwd_reset_lx
;;
*)echo "This script add users in AIX and Linux servers"
;;
esac
