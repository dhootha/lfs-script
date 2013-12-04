#!/bin/bash
################################################################################
# Функция "f_system"
# Version: 0.1

f_system ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

local BASE_CORE_FLAG=0
local SYSTEM_FLAG=0
case ${SYSTEM_LFS_FLAG} in
	0)
		if [ "${CHROOT_FLAG}" -ne 0 ] || [ "${BLFS_FLAG}" -ne 0 ]
		then BASE_CORE_FLAG=1
		else return 0
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
		color-echo 'Не верный параметер константы "SYSTEM_LFS_FLAG"' ${RED} && exit 1
		;;
esac

color-echo "f_system" ${YELLOW}

if [ "$(mount | grep ${LFS}${BUILD_DIR})" ]; then
	umount -v ${BUILD_DIR}
fi

#if [ "$(cat ${LFS_LOG}/tools_lfs-flag)" -gt 0 ]; then
#	color-echo "ERROR: 0p_flag" ${RED}
#	return `cat ${LFS_LOG}/tools_lfs-flag`
#fi

date > "${LFS_LOG}/system.log"

rm -Rf ${BUILD_DIR}
# --------------------------------
install -dv "${LFS}${LFS_PWD}"
mount --bind ${LFS_PWD} "${LFS}${LFS_PWD}"
# --------------------------------
mkdir -pv ${LFS}/{dev,proc,sys}
mknod -m 600 "${LFS}/dev/console" c 5 1
mknod -m 666 "${LFS}/dev/null" c 1 3
mount -v --bind /dev "${LFS}/dev"
mount -vt devpts devpts "${LFS}/dev/pts" -o gid=5,mode=620
mount -vt proc proc "${LFS}/proc"
mount -vt sysfs sysfs "${LFS}/sys"

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
sed 's/tools/usr/' /tools/lib/libstdc++.la > ${LFS}/usr/lib/libstdc++.la
ln -sv bash ${LFS}/bin/sh

install -d ${LFS}/etc
ln -sv /proc/self/mounts ${LFS}/etc/mtab
# ++++++++++++++++++++++++++++++++
install -d ${LFS_PKG}
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
sed -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'${J2_LFS_FLAG}'"/' \
    -i /tools/etc/makepkg.conf
# ++++++++++++++++++++++++++++++++
mkdir -p ${LFS}/var/{log,lib/pacman,cache/pacman/pkg}
touch ${LFS}/var/log/pacman.log
echo '
DBPath      = /var/lib/pacman/
CacheDir    = /var/cache/pacman/pkg/
LogFile     = /var/log/pacman.log' >> /tools/etc/pacman.conf
# ++++++++++++++++++++++++++++++++

# base-core
if [ "${BASE_CORE_FLAG}" -gt 0 ] || [ "${SYSTEM_FLAG}" -gt 0 ] || [ "${BLFS_FLAG}" -gt 0 ]; then
	f_chroot "${LFS_PWD}/_chroot/f_system_base.sh"
else
	echo ${BASE_CORE_FLAG} > "${LFS_LOG}/system_base-flag"
fi
[[ `cat "${LFS_LOG}/system_base-flag"` -eq 0 ]] || return `cat "${LFS_LOG}/system_base-flag"`

# Настройка DNS
install -d ${LFS}/etc
cp -v /etc/{resolv.conf,hosts} ${LFS}/etc/
cp -v /etc/{resolv.conf,hosts} /tools/etc/

# chroot
if [ "${CHROOT_FLAG}" -gt 0 ]; then
	f_chroot
fi

# system
if [ "${SYSTEM_FLAG}" -gt 0 ] || [ "${BLFS_FLAG}" -gt 0 ]; then
	f_chroot "${LFS_PWD}/_chroot/f_system.sh"
else
	echo ${SYSTEM_FLAG} > "${LFS_LOG}/system-flag"
fi

[[ `cat "${LFS_LOG}/system-flag"` -eq 0 ]] || return `cat "${LFS_LOG}/system-flag"`

color-echo 'Завершение работы: f_system ()' ${GREEN}
date >> "${LFS_LOG}/system.log"
}

################################################################################
