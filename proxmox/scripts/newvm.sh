#!/bin/bash

if [[ $# -ne 4 ]]; then
    printf "Illegal number of parameters\n./newvm.sh <id> <name> <ip> <disk_size>\n" >&2
    exit 1
fi

id=$1
name=$2
ip=$3
disk_size=$4

printf "Password: "
read -s password
echo

printf "\nClone\n"
qm clone 9000  $id --name $name
if [ $? -ne 0 ]; then
  printf "Error: Failed to clone\n"
  exit 1
fi

printf "\nSet ip, gateway\n"
qm set $id --ipconfig0 ip=$ip/24,gw=192.168.0.1
if [ $? -ne 0 ]; then
  printf "Error: Failed to set ip or gw\n"
  exit 1
fi

printf "\nResize disk\n"
qm resize $id scsi0 +$disk_size
if [ $? -ne 0 ]; then
  printf "Error: Failed to set disk size\n"
  exit 1
fi

printf "\nSet password\n"
qm set $id --cipassword "$password"
if [ $? -ne 0 ]; then
  printf "Error: Failed to set password\n"
  exit 1
fi

printf "\nStart vm\n"
qm start $id
if [ $? -ne 0 ]; then
  printf "Error: Failed to start vm\n"
  exit 1
fi

printf "VM is starting, cloud-init needs a minute or two.\n"
printf "SSH (key only): ssh debian@%s\n" "$ip"
printf "Password is for the Proxmox console only (SSH password login is disabled)."
