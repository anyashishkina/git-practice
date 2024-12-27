#!/bin/bash

ip_address="$1"

IFS='.'
read -r -a mas <<< "$ip_address"

new_ip_address=""
for el in "${mas[@]}"; do
        new_el=$(echo "obase=2;$el" | bc)
        new_el=$(printf "%08d" $new_el)
        new_ip_address="$new_ip_address.$new_el"
done

echo "${new_ip_address:1}"
