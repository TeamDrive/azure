#!/bin/bash

# All stuff ends up in /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0

yum -y update
yum -y install mdadm

# Standard fdisk partition
fdiskStdin=$(cat <<'END_HEREDOC'
n
p
1


w
END_HEREDOC
)

# cfdisk command for 'FD' (RAID autodetect) for RAID
cfdiskStdinFD=$(cat <<'END_HEREDOC'
np

tFD
Wyes
q
END_HEREDOC
)

# cfdisk command for '8E' (LVM)
cfdiskStdin8E=$(cat <<'END_HEREDOC'
np

t8E
Wyes
q
END_HEREDOC
)

# Use 'cfdisk' on /dev/sdc and create a primary partition of type 'FD' (RAID autodetect) for RAID for pg_data
echo "$cfdiskStdinFD" | cfdisk /dev/sdc

# Use 'cfdisk' on /dev/sdd and create a primary partition of type 'FD' (RAID autodetect) for RAID for pg_data
echo "$cfdiskStdinFD" | cfdisk /dev/sdd

mdadm --create /dev/md0 --level 0 --raid-devices 2 /dev/sdc1 /dev/sdd1

# create physical volume
pvcreate /dev/md0

# create volume group
vgcreate data /dev/md0

# create logical volume
lvcreate -n sqldata -l100%FREE data

# show volume group information
vgdisplay

mkfs.xfs /dev/data/sqldata

mkdir /mnt/datadisks

echo -e "/dev/mapper/data-sqldata\t/mnt/datadisks\txfs\tdefaults\t0\t0" >> /etc/fstab
