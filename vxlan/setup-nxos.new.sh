#!/bin/sh

echo "At each password prompt, enter the password for each of the switches:"

for host in $(awk -F: '/ansible_host/ { print $2;}' hosts.sandbox.yml); do 
     echo
     echo "*** CONFIGURING ${host} ***"
     echo
     printf "configure terminal\n
             feature icam\n
             end\n
             copy running-config startup-config\n
             exit\n" | ssh admin@${host}
done
