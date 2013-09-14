#!/bin/bash
#######################################
# system_lfs
# Version: test

_system_lfs ()
{
cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local LFS_FLAG='system-lfs'

local ERR_FLAG=0

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

array_packages || ERR_FLAG=${?}

echo 'system_lfs:' >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"
env >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"

scripts_system '06.Installing Basic System Software' '--log'; rm  -Rf ${LFS_PKG}/test-ld-*
scripts_system '07.Setting Up System Bootscripts' '--log'
scripts_system '08.Making the LFS System Bootable'
#scripts_system '0p.Install pacman' '--log'

if [ "${BLFS_FLAG}" -eq 0 ]; then
	# Журналируем пакеты репозитория
	repo-add_lfs

	# Дефаултные конфиги для рута
	cp -rf `find /etc/skel/ | sed -e '1d'` /root/
fi

if [ "${ERR_FLAG}" -eq 0 ] && [ "${MOUNT_LFS_FLAG}" -ne 0 ]; then
	# fstab
	echo "# Begin /etc/fstab

# file system  mount-point  type   options         dump  fsck
#                                                        order
" > /etc/fstab
	local _disk
	for _disk in `cat ${LFS_PWD}/disk`
	do
		local _section=$(echo ${_disk} | cut -d: -f1)
		local _mount_point=$(echo ${_disk} | cut -d: -f2)
		local _type=$(echo ${_disk} | cut -d: -f3)
		case ${_mount_point} in
		    'swap' ) echo "${_section}      ${_mount_point}         ${_type}   pri=1           0     0" >> /etc/fstab ;;
		    '/' )    echo "${_section}      ${_mount_point}            ${_type}   defaults        1     1" >> /etc/fstab
			     local _ROOT=${_section} ;;
		    * )	     echo "${_section}      ${_mount_point}         ${_type}   defaults        0     0" >> /etc/fstab ;;
		esac
	done
	echo "proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab" >> /etc/fstab

#	install -d /boot/grub
#	grub-mkdevicemap --device-map=/boot/grub/device.map
#echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++'
#	cat /boot/grub/device.map
#echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++'
#	rm -fv /dev/root
#	ln -sv ${_ROOT} /dev/root
	if [ "${MOUNT_LFS_FLAG}" -ne 0 ]; then
		grub-install ${_ROOT:0:8} || ERR_FLAG=${?}
#		grub-install "(hd0)" || ERR_FLAG=${?}
	fi

	cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd1,2)

menuentry "GNU/Linux, Linux lfs-`head -n 1 ${LFS_PWD}/Changelog | cut -d' ' -f2`" {
	linux	/boot/vmlinux ro root=${_ROOT}
}
EOF

	yes 'toor' | passwd
fi

# Инфо о релизе
cat > /etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="`head -n 1 ${LFS_PWD}/Changelog | cut -d' ' -f2`"
DISTRIB_CODENAME="<your name here>"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

echo ${ERR_FLAG} > "${LFS_LOG}/system_lfs-flag"

set +Ee
}

_system_lfs
logout

#######################################
