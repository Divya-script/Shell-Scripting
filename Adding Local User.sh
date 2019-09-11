#
#!/bin/bash
#This script add users in AIX, Linux servers
#

#++++++++++Variables++++++++++++++++++++++++++++++
read -p "enter username: " user
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

usr_add_aix()
{
ssh -q $host "grep $user /etc/passwd" > /dev/null 2>&1
if [[ $? -ne 0 ]]
then
        read -p 'please enter comment: ' comment
        read -p 'please enter password: ' pass
        ssh $host "sudo /usr/sbin/useradd -c \"${comment}\" ${user}"
#       ssh -q $host "echo \"${pass}\" | sudo /usr/bin/passwd --stdin ${user}"
        ssh -q $host "echo \"${user}:${pass}\" | sudo /usr/bin/chpasswd -c"
        ssh -q $host "sudo /usr/bin/pwdadm -c ${user}"
else
        echo "$user already exist in $host"
fi
}

usr_add_lx()
{
ssh $host <<EOSSH
grep $user /etc/passwd" > /dev/null 2>&1
if [[ $? -ne 0 ]]
then
        read -p 'please enter comment: ' comment
        read -p 'please enter password: ' pass
        useradd -c \"${comment}\" $user
        echo pass | passwd --stdin $user
        passwd -e $user
else
        echo "$user already exist in $host"
fi
EOSSH
}


#+++++++++++++main function ++++++++++++++++++++++++++++++++++
os=$(u_name_chk)
case "$os" in
AIX) usr_add_aix
;;
Linux) usr_add_lx
;;
*)echo "This script add users in AIX and Linux servers"
;;
esac

