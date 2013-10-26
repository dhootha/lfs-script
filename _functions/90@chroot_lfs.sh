#!/bin/bash
################################################################################
# Функция "chroot"
# Version: 0.1

chroot_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

if [ -z "${1}" ]; then
	if [ "${CHROOT_FLAG}" -gt 0 ]; then
		color-echo "!!! CHROOT !!!" ${YELLOW}
		date > "${LFS_LOG}/chroot.log"
	else
		return 0
	fi
fi

if [ -f ${LFS}/usr/bin/env ]
then	local _ENV=/usr/bin/env
else	local _ENV=/tools/bin/env
fi

if [ -f ${LFS}/bin/bash ] && [ ! -h ${LFS}/bin/bash ]
then    local _BASH=/bin/bash
else    local _BASH=/tools/bin/bash
fi

# Входим в chroot
chroot ${LFS} ${_ENV} -i \
	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
	PREFIX_LFS="${PREFIX_LFS}" LFS_PWD="${LFS_PWD}" LFS_SRC="${LFS_SRC}" LFS_PKG="${LFS_PKG}" \
	ns1_IP="${ns1_IP}" ns2_IP="${ns2_IP}" BUILD_DIR="${BUILD_DIR}" LFS_OUT="${LFS_OUT}" LFS_LOG="${LFS_LOG}" \
	HOSTNAME="${HOSTNAME}" PACKAGE_MANAGER="${PACKAGE_MANAGER}" PACKAGE_MANAGER_FLAG="${PACKAGE_MANAGER_FLAG}" \
	PATH="${PATH_CHROOT}" _LOG="${_LOG}" BLFS_FLAG="${BLFS_FLAG}" MOUNT_LFS_FLAG="${MOUNT_LFS_FLAG}" \
	PACKAGE_FORCE="${PACKAGE_FORCE[*]}" PACKAGE_GROUPS="${PACKAGE_GROUPS[*]}" \
	${_BASH} --login +h "${1}"

if [ -z "${1}" ]; then
	color-echo 'Завершение работы: chroot ()' ${GREEN}
	date >> "${LFS_LOG}/chroot.log"
fi
}

################################################################################
