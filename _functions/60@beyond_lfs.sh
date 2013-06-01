#!/bin/bash
################################################################################
# Функция "blfs"
# Version: 0.1

beyond_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}
[ "${BLFS_FLAG}" -eq 0 ] && return 0

color-echo "!!! BLFS !!!" ${YELLOW}

if [ ! -f ${LFS_LOG}/system_lfs-flag ] || [ "$(cat ${LFS_LOG}/system_lfs-flag)" -gt 0 ]; then
	color-echo "ERROR: system_lfs_flag" ${RED}
	return 1
fi

if [ -n "$(mount | grep ${LFS}${BUILD_DIR})" ]; then
	umount -v ${BUILD_DIR}
fi

date > "${LFS_LOG}/blfs.log"

# Каталог для хронения лог-файлов blfs
local _LOG="${LFS_LOG}/blfs"
install -d ${_LOG}

# blfs
chroot_lfs "${LFS_PWD}/_chroot/_beyond_lfs.sh"

if [ ! -f ${LFS_LOG}/blfs-flag ] || [ "$(cat ${LFS_LOG}/blfs-flag)" -gt 0 ]; then
	return 1
fi

color-echo 'Завершение работы: blfs ()' ${GREEN}
date >> "${LFS_LOG}/blfs.log"
}

################################################################################
