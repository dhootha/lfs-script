#!/bin/bash
################################################################################
# Функция "system_lfs"
# Version: 0.1

system_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}
[ -f ${LFS_LOG}/tools_lfs-flag ] || return ${ERR_FLAG}

color-echo "system_lfs" ${YELLOW}

if [ "$(mount | grep ${LFS}${BUILD_DIR})" ]; then
	umount -v ${BUILD_DIR} || return ${?}
fi

local BASE_CORE_FLAG=0
local SYSTEM_FLAG=0
case ${SYSTEM_LFS_FLAG} in
	0)
		if [ "${CHROOT_FLAG}" -ne 0 ] || [ "${BLFS_FLAG}" -ne 0 ]; then
			BASE_CORE_FLAG=1
		fi
		;;
	1)
		BASE_CORE_FLAG=1
		;;
	2)
		SYSTEM_FLAG=1
		;;
	3)
		BASE_CORE_FLAG=1
		SYSTEM_FLAG=1
		;;
	*)
		color-echo 'Не верный параметер константы "SYSTEM_LFS_FLAG"' ${RED} && return 1
		;;
esac

#if [ ${PACKAGE_MANAGER_FLAG} -ne 0 ]; then
if [ "$(cat ${LFS_LOG}/tools_lfs-flag)" -gt 0 ]; then
	color-echo "ERROR: 0p_flag" ${RED}
	return 1
fi
#	rm -Rf "${LFS_SRC}/system_lfs.tar.bz2"
#fi

date > "${LFS_LOG}/system_lfs.log"

rm -Rf ${BUILD_DIR}
# --------------------------------
install -dv "${LFS}${LFS_PWD}"
mount --bind ${LFS_PWD} "${LFS}${LFS_PWD}" || return 1
# --------------------------------
mkdir -pv ${LFS}/{dev,proc,sys} || return 1
mknod -m 600 "${LFS}/dev/console" c 5 1 || return 1
mknod -m 666 "${LFS}/dev/null" c 1 3 || return 1
mount -v --bind /dev "${LFS}/dev" || return 1
mount -vt devpts devpts "${LFS}/dev/pts" || return 1
mount -vt proc proc "${LFS}/proc" || return 1
mount -vt sysfs sysfs "${LFS}/sys" || return 1

if [ -h $LFS/dev/shm ]; then
   link=$(readlink $LFS/dev/shm)
   mkdir -p $LFS/$link
   mount -vt tmpfs shm $LFS/$link
   unset link
else
   mount -vt tmpfs shm $LFS/dev/shm
fi

# ++++++++++++++++++++++++++++++++
mkdir -pv ${LFS}/bin ${LFS}/usr/{bin,lib}
ln -sv /tools/bin/{bash,cat,echo,pwd,stty} ${LFS}/bin
ln -sv /tools/bin/{perl,du,strip} ${LFS}/usr/bin
ln -sv /tools/lib/{libgcc_s.so{,.1},libstdc++.so{,.6}} ${LFS}/usr/lib
#ln -sv /tools/lib/libstdc++.so{,.6} ${LFS}/usr/lib
ln -sv bash ${LFS}/bin/sh
# ++++++++++++++++++++++++++++++++
mkdir -p ${LFS_PKG}
echo "
PKGDEST=${LFS_PKG}
SRCDEST=${LFS_SRC}" >> /tools/etc/makepkg.conf
echo 'XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u' >> /tools/etc/pacman.conf
sed -e "s/PKGEXT='.pkg.tar.gz'/PKGEXT='.pkg.tar.xz'/" \
    -e 's/OPTIONS=(strip docs libtool emptydirs zipman purge)/OPTIONS=(strip !docs libtool emptydirs zipman purge)/' \
    -i /tools/etc/makepkg.conf
#    -e 's/{man,info}/{man}/g' \
#    -e 's/{doc,/{doc,info,/g' \
#    -i /tools/etc/makepkg.conf
# ++++++++++++++++++++++++++++++++
#if [ ${J2_LFS_FLAG} -eq 1 ]; then
sed -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'${J2_LFS_FLAG}'"/' \
    -i /tools/etc/makepkg.conf
#fi
# ++++++++++++++++++++++++++++++++
mkdir -p ${LFS}/var/{log,lib/pacman,cache/pacman/pkg}
touch ${LFS}/var/log/pacman.log
#sed -i "s/\/tools//g" /tools/etc/pacman.conf
echo '
DBPath      = /var/lib/pacman/
CacheDir    = /var/cache/pacman/pkg/
LogFile     = /var/log/pacman.log' >> /tools/etc/pacman.conf
# ++++++++++++++++++++++++++++++++

cat /etc/mtab | grep /mnt/lfs | sed -e 's/\/mnt\/lfs//g' > ${LFS_LOG}/mtab
install -d /mnt/lfs/etc
cat ${LFS_LOG}/mtab > /mnt/lfs/etc/mtab
echo 'rootfs / rootfs rw 0 0' >> /mnt/lfs/etc/mtab

# Каталог для хронения лог-файлов system
local _LOG="${LFS_LOG}/system"
install -d ${_LOG}

# base-core
if [ "${BASE_CORE_FLAG}" -gt 0 ] || [ "${SYSTEM_FLAG}" -gt 0 ] || [ "${BLFS_FLAG}" -gt 0 ]; then
chroot ${LFS} /tools/bin/env -i \
	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
	PREFIX=${PREFIX} LFS_PWD=${LFS_PWD} LFS_SRC=${LFS_SRC} LFS_PKG=${LFS_PKG} \
	ns1_IP=${ns1_IP} ns2_IP=${ns2_IP} BUILD_DIR=${BUILD_DIR} LFS_OUT="${LFS_OUT}" LFS_LOG="${LFS_LOG}" \
	HOSTNAME=${HOSTNAME} PACKAGE_MANAGER=${PACKAGE_MANAGER} PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG} \
	PATH='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin' _LOG="${_LOG}" \
	/tools/bin/bash --login +h ${LFS_PWD}/_chroot/_system_base_lfs.sh
else
	echo ${BASE_CORE_FLAG} > "${LFS_LOG}/system_base_lfs-flag"
fi
[[ $(cat "${LFS_LOG}/system_base_lfs-flag") -eq 0 ]] || return 1

cat ${LFS_LOG}/mtab > /mnt/lfs/etc/mtab
echo 'rootfs / rootfs rw 0 0' >> /mnt/lfs/etc/mtab

# chroot
chroot_lfs || return ${?}
#if [ "${CHROOT_FLAG}" -gt 0 ]; then
#chroot ${LFS} /tools/bin/env -i \
#	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
#	PREFIX=${PREFIX} LFS_PWD=${LFS_PWD} LFS_SRC=${LFS_SRC} LFS_PKG=${LFS_PKG} \
#	ns1_IP=${ns1_IP} ns2_IP=${ns2_IP} BUILD_DIR=${BUILD_DIR} LFS_OUT="${LFS_OUT}" LFS_LOG="${LFS_LOG}" \
#	HOSTNAME=${HOSTNAME} MOUNT_LFS_FLAG=${MOUNT_LFS_FLAG} PACKAGE_MANAGER=${PACKAGE_MANAGER} \
#	PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG} _LOG="${_LOG}" \
#	PATH='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin' \
#	/tools/bin/bash --login +h
#fi

# system
if [ "${SYSTEM_FLAG}" -gt 0 ] || [ "${BLFS_FLAG}" -gt 0 ]; then
chroot ${LFS} /tools/bin/env -i \
	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
	PREFIX=${PREFIX} LFS_PWD=${LFS_PWD} LFS_SRC=${LFS_SRC} LFS_PKG=${LFS_PKG} \
	ns1_IP=${ns1_IP} ns2_IP=${ns2_IP} BUILD_DIR=${BUILD_DIR} LFS_OUT="${LFS_OUT}" LFS_LOG="${LFS_LOG}" \
	HOSTNAME=${HOSTNAME} MOUNT_LFS_FLAG=${MOUNT_LFS_FLAG} PACKAGE_MANAGER=${PACKAGE_MANAGER} \
	PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG} _LOG="${_LOG}" BLFS_FLAG=${BLFS_FLAG} \
	PATH='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin' \
	/tools/bin/bash --login +h ${LFS_PWD}/_chroot/_system_lfs.sh
else
	echo ${SYSTEM_FLAG} > "${LFS_LOG}/system_lfs-flag"
fi

[[ "$(cat ${LFS_LOG}/system_lfs-flag)" -eq 0 ]] || return ${?}

color-echo 'Завершение работы: system_lfs ()' ${GREEN}
date >> "${LFS_LOG}/system_lfs.log"
}

################################################################################
