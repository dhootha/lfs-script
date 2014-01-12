#!/bin/bash

mkdir -pv ${1}/{bin,boot,etc/sysconfig,home,lib,mnt,run}
mkdir -pv ${1}/{sbin,var}
install -dv -m 0750 ${1}/root
install -dv -m 1777 ${1}/tmp ${1}/var/tmp
mkdir -pv ${1}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${1}/usr/{,local/}share/{locale,man}
mkdir -v  ${1}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${1}/usr/{,local/}share/man/man{1..8}
for dir in ${1}/usr ${1}/usr/local; do
  ln -sv share/man ${dir}
done
case $(uname -m) in
  x86_64)
	ln -sv lib ${1}/lib64 && \
	ln -sv lib ${1}/usr/lib64 && \
	ln -sv lib ${1}/usr/local/lib64
  ;;
esac
mkdir -v ${1}/var/{log,mail,spool}
ln -sv /run ${1}/var/run
ln -sv /run/lock ${1}/var/lock
mkdir -pv ${1}/var/{cache,lib/{misc,locate},local}
