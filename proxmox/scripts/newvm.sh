#!/bin/bash

if [[ $# -ne 4 ]]; then
    printf "Illegal number of parameters\n./newvm.sh <id> <name> <ip> <final_disk_size_in_gb>\n" >&2
    exit 1
fi

id="$1"
name="$2"
ip="$3"
disk_size="$4"

if [[ ! "$disk_size" =~ ^[1-9][0-9]*$ ]] || [ "$disk_size" -lt 3 ]; then
  printf "Error: Disk size cannot be smaller than 3GB, AND IT HAS TO BE A NUMBER, given by user: %s\n" "$disk_size" >&2
  exit 1
fi

ping -c 1 -W 1 "$ip" > /dev/null
if [ $? -eq 0 ]; then
  printf "Error: IP: %s already taken, please try different one\n" "$ip" >&2
  exit 1
fi

printf "\nChecking if ID: %s is available\n" "$id"
qm status "$id" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  printf "Error: ID: %s unavailable\n" "$id" >&2
  exit 1
fi

printf "Password: "
read -s -r password
echo

printf "\nClone\n"
qm clone 9000 "$id" --name "$name" > /dev/null
if [ $? -ne 0 ]; then
  printf "Error: Failed to clone\n" >&2
  exit 1
fi

printf "\nSet ip, gateway\n"
qm set "$id" --ipconfig0 ip="$ip"/24,gw=192.168.0.1 > /dev/null
if [ $? -ne 0 ]; then
  printf "Error: Failed to set ip or gw\n" >&2
  exit 1
fi

printf "\nResize disk\n"
qm disk resize "$id" scsi0 "$disk_size"G > /dev/null
if [ $? -ne 0 ]; then
  printf "Error: Failed to set disk size\n" >&2
  exit 1
fi

printf "\nSet password\n"
qm set "$id" --cipassword "$password" > /dev/null
if [ $? -ne 0 ]; then
  printf "Error: Failed to set password\n" >&2
  exit 1
fi

printf "\nStart vm\n"
qm start "$id" > /dev/null
if [ $? -ne 0 ]; then
  printf "Error: Failed to start vm\n" >&2
  exit 1
fi

printf "VM is starting, cloud-init needs a minute or two.\n"
printf "SSH (key only): ssh debian@%s\n" "$ip"
printf "Password is for the Proxmox console only (SSH password login is disabled).\n"
