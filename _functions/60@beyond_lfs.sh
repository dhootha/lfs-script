#!/bin/bash
################################################################################
# Функция "blfs"
# Version: 0.1

beyond_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}
[ -f ${LFS_LOG}/system_lfs-flag ] || return ${ERR_FLAG}

color-echo "!!! BLFS !!!" ${YELLOW}

if [ "$(mount | grep ${LFS}${BUILD_DIR})" ]; then
	umount -v ${BUILD_DIR} || return ${?}
fi

if [ "$(cat ${LFS_LOG}/system_lfs-flag)" -gt 0 ]; then
	color-echo "ERROR: system_lfs_flag" ${RED}
	return "$(cat ${LFS_LOG}/system_lfs-flag)"
fi

date > "${LFS_LOG}/blfs.log"

# --------------------------------
#install -dv "${LFS}${LFS_PWD}"
#mount --bind ${LFS_PWD} "${LFS}${LFS_PWD}" || return ${?}
# --------------------------------

# Каталог для хронения лог-файлов blfs
local _LOG="${LFS_LOG}/blfs"
install -d ${_LOG}

# blfs
if [ "${BLFS_FLAG}" -gt 0 ]; then
chroot ${LFS} /usr/bin/env -i \
	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
	PREFIX=${PREFIX} LFS_PWD=${LFS_PWD} LFS_SRC=${LFS_SRC} LFS_PKG=${LFS_PKG} \
	ns1_IP=${ns1_IP} ns2_IP=${ns2_IP} BUILD_DIR=${BUILD_DIR} LFS_LOG="${LFS_LOG}" \
	HOSTNAME=${HOSTNAME} PACKAGE_MANAGER=${PACKAGE_MANAGER} _LOG="${_LOG}" \
	PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG} PACKAGE_GROUPS=${PACKAGE_GROUPS} \
	PATH='/bin:/usr/bin:/sbin:/usr/sbin' \
	/bin/bash --login +h ${LFS_PWD}/_chroot/_beyond_lfs.sh
else
	echo ${BLFS_FLAG} > "${LFS_LOG}/blfs-flag"
fi

[[ "$(cat ${LFS_LOG}/blfs-flag)" -eq 0 ]] || return 1

color-echo 'Завершение работы: blfs ()' ${GREEN}
date >> "${LFS_LOG}/blfs.log"
}

################################################################################
