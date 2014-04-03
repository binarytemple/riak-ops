#!/usr/bin/env bash

# set ulimits
sudo sh -c 'echo \
"* soft nofile 65536
* hard nofile 65536" \
>> /etc/security/limits.conf'

# set these values in sysctl.conf
sudo sh -c 'echo \
"vm.swappiness=0
net.core.wmem_default=8388608
net.core.rmem_default=8388608
net.core.wmem_max=8388608
net.core.rmem_max=8388608
net.core.netdev_max_backlog=10000
net.core.somaxconn=4000
net.ipv4.tcp_max_syn_backlog=40000
net.ipv4.tcp_fin_timeout=15
net.ipv4.tcp_tw_reuse=1" \
>> /etc/sysctl.conf'

# make changes effective
sudo sysctl -p