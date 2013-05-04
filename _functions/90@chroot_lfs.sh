#!/bin/bash
################################################################################
# Функция "chroot"
# Version: 0.1

chroot_lfs ()
{
if [ "${CHROOT_FLAG}" -eq 0 ]; then
	return 0
fi

color-echo "!!! CHROOT !!!" ${YELLOW}

date > "${LFS_LOG}/chroot.log"

if [ -f ${LFS}/usr/bin/env ]
then	local _ENV=/usr/bin/env
else	local _ENV=/tools/bin/env
fi

# Входим в chroot
chroot ${LFS} ${_ENV} -i \
	HOME='/root' TERM=${TERM} PS1='\u:\w\$ ' \
	PREFIX=${PREFIX} LFS_PWD=${LFS_PWD} LFS_SRC=${LFS_SRC} LFS_PKG=${LFS_PKG} \
	ns1_IP=${ns1_IP} ns2_IP=${ns2_IP} BUILD_DIR=${BUILD_DIR} LFS_OUT="${LFS_OUT}" LFS_LOG="${LFS_LOG}" \
	HOSTNAME=${HOSTNAME} PACKAGE_MANAGER=${PACKAGE_MANAGER} PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG} \
	PATH='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin' \
	/tools/bin/bash --login +h

color-echo 'Завершение работы: chroot ()' ${GREEN}
date >> "${LFS_LOG}/chroot.log"
}

################################################################################
