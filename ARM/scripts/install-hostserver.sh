#!/bin/bash

# All stuff ends up in /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0

hostserverIP=$1
hostserverFQDN=$2
regserverIP=$3
regserverFQDN=$4
webportalIP=$5
webportalFQDN=$6

echo "$hostserverIP"   > hostserverIP.txt
echo "$hostserverFQDN" > hostserverFQDN.txt
echo "$regserverIP"    > regserverIP.txt
echo "$regserverFQDN"  > regserverFQDN.txt
echo "$webportalIP"    > webportalIP.txt
echo "$webportalFQDN"  > webportalFQDN.txt

yum update -y --exclude=WALinuxAgent
yum -y install httpd
service httpd start
