#!/bin/bash

install -dv ${1}/etc
cat > ${1}/etc/vconsole.conf << EOF
# Begin /etc/vconsole.conf

UNICODE="1"
KEYMAP="ru_ru-utf8"
FONT="cyr-sun16"

# End /etc/vconsole.conf
EOF
