#!/bin/bash
#######################################
# Cross-LFS
# Version: test

_lfs ()
{
# constants

local LFS_PWD=`echo "${0}" | sed -e s@/$(basename "${0}")@@g`
[ "${LFS_PWD}" == '.' ] && local LFS_PWD=`pwd`
local PREFIX='svn'
local LFS='/mnt/lfs'
local LFS_SRC="${LFS_PWD}/${PREFIX}/sources"
local LFS_OUT="${LFS_PWD}/output"
local LFS_PKG="${LFS_OUT}/pkg"
local LFS_LOG="${LFS_OUT}/log"
local BUILD_DIR="${LFS_PWD}/build"

local PACKAGE_MANAGER='pacman'

local PACKAGE_GROUPS=('base' 'base-devel')
local PACKAGE_FORCE=('base-core' 'glibc' 'binutils' 'gcc' 'shadow' 'coreutils' 'bash' 'perl' 'bash-completion')

local HOSTNAME='inet'
local ns1_IP='8.8.4.4'
local ns2_IP='8.8.8.8'
local PATH_CHROOT='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin'

# flags
local LFS_FLAG='lfs'
local CHROOT_FLAG=0
local J2_LFS_FLAG="$(( `grep -c '^processor' /proc/cpuinfo` + 1 ))"
local PACKAGE_MANAGER_FLAG=1
local MOUNT_LFS_FLAG=0
local PACKAGES_LFS_FLAG=1
local TOOLS_LFS_FLAG=3		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local SYSTEM_LFS_FLAG=0		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local BLFS_FLAG=0
local ERR_FLAG=0

[ -n "$(grep ^i: /etc/passwd 2> /dev/null)" ] && chown i:i -R ${LFS_PWD}

#. ${LFS_PWD}/${PREFIX}/packages-lfs.conf
for _functions in ${LFS_PWD}/_functions/*.sh
do
	source ${_functions}
done

# Размонтирование разделов.
umount_lfs || exit ${?}

local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

# Подготовка и монтирование разделов.
mount_lfs

# Назначение переменных (массивов) хроняших информацию о пакетах.
array_packages

# Скачиваем пакеты.
packages_lfs

# Создание необходимых каталогов и сборка временной системы.
tools_lfs

#echo ${ERR_FLAG} > ${LFS_LOG}/tools_lfs-flag

# Сборка основной системы.
system_lfs

# Сборка BLFS.
beyond_lfs

# Входим в chroot
chroot_lfs

# Размонтирование разделов и очистка системы.
umount_lfs

[ -n "$(grep ^i: /etc/passwd 2> /dev/null)" ] && chown i:i -R ${LFS_PWD}

set +Ee
}

setterm -blank 0
_lfs

#######################################
