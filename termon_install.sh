#!/usr/bin/bash

# This file installs sysstat as required by termon, downloads termon code
# and turns it into 'termon' command.

yum install sysstat -y
mkdir /termon_dir
wget -4 https://raw.githubusercontent.com/YashIndane/termon/main/termon.sh -P /termon_dir
chmod +x /termon_dir/termon.sh
ln -s /termon_dir/termon.sh /bin/termon
