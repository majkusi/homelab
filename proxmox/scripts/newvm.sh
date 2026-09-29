#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo "Illegal number of parameters\n
    ./newvm.sh <id> <name> <ip> <disk_size>" >&2
    exit 1
fi

id=$1
name=$2
ip=$3
disk_size=$4

echo -n Password:
read -s password
echo

printf "\nClone\n"
qm clone 9000  $id --name $name
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone"
  exit 1
fi

printf "\nSet ip, gateway\n"
qm set $id --ipconfig0 ip=$ip/24,gw=192.168.0.1
if [ $? -ne 0 ]; then
  echo "Error: Failed to set ip or gw"
  exit 1
fi

printf "\nReside disk\n"
qm resize $id scsi0 +$disk_size
if [ $? -ne 0 ]; then
  echo "Error: Failed to set disk size"
  exit 1
fi

printf "\nSet password\n"
qm set $id --cipassword "$password"
if [ $? -ne 0 ]; then
  echo "Error: Failed to set password"
  exit 1
fi

printf "\nStart vm\n"
qm start $id
if [ $? -ne 0 ]; then
  echo "Error: Failed to start vm"
  exit 1
fi

printf "To connect to created VM use:\n
SSH - debian@$ip\n
with username: debian\n
and password given at the start of the script :)
\n"