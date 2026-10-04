#!/bin/bash

if [[ $# -ne 1 ]]; then
    printf "Illegal number of parameters\n./delvm.sh <id>\n" >&2
    exit 1
fi

id=$1
if [[ $id -ge 9000 ]]; then
    printf "Error: This script can't operate on ID: %s. IDs 9000+ are reserved for templates\n" "$id" >&2
    exit 1
fi

printf "Checking status of VM with ID:%s\n" "$id"
qm status "$id" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    printf "Error: VM with ID: %s does not exist\n" "$id" >&2
    exit 1
fi

printf "Stopping VM with ID:%s\n" "$id"
qm stop "$id"
if [ $? -ne 0 ]; then
    printf "Error: Failed to stop machine ID:%s\n" "$id" >&2
    exit 1
fi

printf "Destroying VM with ID:%s\n" "$id"
qm destroy "$id" --purge
if [ $? -ne 0 ]; then
    printf "Error: Failed to destroy machine ID:%s\n" "$id" >&2
    exit 1
fi

printf "VM with ID:%s was successfully destroyed\n" "$id"
