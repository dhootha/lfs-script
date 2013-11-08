#!/bin/bash

install -d ${1}/etc/sysconfig
#cat > ${1}/etc/sysconfig/ifconfig.eth0 << EOF
#ONBOOT=yes
#IFACE=eth0
#SERVICE=ipv4-static
#IP=10.5.14.227
#GATEWAY=10.5.12.8
#PREFIX=22
#BROADCAST=10.5.15.255
#EOF

#cat > ${1}/etc/resolv.conf << EOF
## Begin /etc/resolv.conf
#
##domain <Your Domain Name>
#nameserver ${ns1_IP}
#nameserver ${ns2_IP}
#
## End /etc/resolv.conf
#EOF

cat > ${1}/etc/hosts << EOF
# Begin /etc/hosts (network card version)

127.0.0.1 ${HOSTNAME} localhost

# End /etc/hosts (network card version)
EOF
