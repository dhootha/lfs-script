#!/bin/bash

install -d ${1}/etc/sysconfig
cat > ${1}/etc/sysconfig/console << EOF
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="ru_ru-utf8"
FONT="cyr-sun16"

# End /etc/sysconfig/console
EOF
