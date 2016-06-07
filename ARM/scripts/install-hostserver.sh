#!/bin/bash

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
