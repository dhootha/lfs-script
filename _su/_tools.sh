#!/bin/bash
################################################################################
# Функция "_tools_lfs"
# Version: 0.1

_tools_lfs ()
{
cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local LFS_FLAG='_tools-lfs'

local TOOLS_LFS_FLAG=${1}
local SYSTEM_LFS_FLAG=${2}
local BLFS_FLAG=${3}
local CHROOT_FLAG=${4}

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

# Удаляем запуск скрипта.
sed -e "/\/_su\/_tools.sh/d" \
    -e '/^exit/d' \
    -i ~/.bashrc

# Назначение переменных (массивов) хроняших информацию о пакетах.
array_packages

# Каталог для хронения лог-файлов tools
_LOG="${LFS_LOG}/tools"
install -d ${_LOG}

case ${TOOLS_LFS_FLAG} in
	3)	# 11
		scripts_tools '05.Constructing Cross-Compile Tools'	#-1
		scripts_tools 'pm.Pacman'	#1-
		;;
	2)	# 10
		scripts_tools 'pm.Pacman' '05.Constructing Cross-Compile Tools'	#1-
		;;
	1)	# -1
		scripts_tools '05.Constructing Cross-Compile Tools'		#-1
		;;
	0)	# 00
		if [ "${CHROOT_FLAG}" -gt 0 ] || \
		   [ "${SYSTEM_LFS_FLAG}" -gt 0 ] || \
		   [ "${BLFS_FLAG}" -gt 0 ]; then
			untar_lfs 'pm.Pacman' '05.Constructing Cross-Compile Tools'	#1-
		else
			return 0
		fi
		;;
	*) echo 'Не верный параметер константы "TOOLS_LFS_FLAG"' ;;
esac

set +Ee
}

_tools_lfs $*

################################################################################
