#!/bin/bash

# All stuff ends up in /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0

yum update -y --exclude=WALinuxAgent
yum -y install mdadm
