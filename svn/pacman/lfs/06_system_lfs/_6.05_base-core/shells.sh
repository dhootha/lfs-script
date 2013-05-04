#!/bin/bash

install -d ${1}/etc

cat > ${1}/etc/shells << "EOF"
# Begin /etc/shells

/bin/sh

# End /etc/shells
EOF
