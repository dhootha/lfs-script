#!/bin/bash

install -dv ${1}/etc
echo ${HOSTNAME} > ${1}/etc/hostname
