#!/bin/bash
#######################################
# Cross-LFS
# Version: test

_lfs ()
{
# constants

which ntpdate && ntpdate 0.europe.pool.ntp.org

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
local PACKAGES_LFS_FLAG=0
local TOOLS_LFS_FLAG=0		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local SYSTEM_LFS_FLAG=0		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local BLFS_FLAG=0
local ERR_FLAG=0

for _ARG in $*
do
	case "${_ARG}" in
		-m | --mount)
			MOUNT_LFS_FLAG=1
		;;
		-t | --tools)
			TOOLS_LFS_FLAG=3
		;;
		-s | --system)
			SYSTEM_LFS_FLAG=3
		;;
		-b | --blfs)
			BLFS_FLAG=1
		;;
		-c | --chroot)
			CHROOT_FLAG=1
		;;
		-d | --download)
			PACKAGES_LFS_FLAG=1
		;;
		--clean)
			if [ -z "$(fgrep "${LFS}" /proc/mounts)" ]; then
				rm -Rfv ${BUILD_DIR} /tools ${LFS}
			else
				color-echo 'Остались смонтированвми ФС!' ${RED}
				exit 1
			fi
			exit
		;;
		*)
			cat << EOF
./lfs.sh [ Опции ]

Опции:
-t | --tools	Сборка пакетов из раздела "5. Constructing a Temporary System" книги LFS
-s | --system	Сборка пакетов из раздела "6. Installing Basic System Software",
		"7. Setting Up System Bootscripts" и "8. Making the LFS System Bootable" книги LFS
-b | --blfs	Сборка пакетов из книги BLFS

-m | --mount	Смонтировать разделы из файла ./disk для новой системы
-c | --chroot	По завершению установки войти в систему с chroot

--clean		Очистка логов и результируюших пакетов
EOF

			exit 0
		;;
	esac
done

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
_lfs "$*"

#######################################
