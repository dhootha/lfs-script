#!/bin/bash
#######################################
# _blfs
# Version: test

_f_beyond ()
{
cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local LFS_FLAG='blfs'

local ERR_FLAG=0

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

array_packages

#hostname ${HOSTNAME}

echo 'blfs:' >> "${LFS_LOG}/blfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/blfs.log"
env >> "${LFS_LOG}/blfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/blfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
        f_build_book "notlfs.pm.${PACKAGE_MANAGER}" '--log'
fi

[ -d /tools ] && rm -Rf /tools

f_build_book 'notlfs.my.base'    '--log'
f_build_book 'blfs.03.base'    '--log'
f_build_book 'blfs.12.base'    '--log'
f_build_book 'blfs.04.openssh' '--log'
f_build_book 'blfs.14.base'    '--log'
f_build_book 'blfs.04.shadow'    '--log'
#scripts_blfs '04_gnupg'  '--log'
#scripts_blfs '04_gnupg2' '--log'

f_repo-add

# Дефаултные конфиги для рута
cp -rf `find /etc/skel/ | sed -e '1d'` /root/

echo ${ERR_FLAG} > "${LFS_LOG}/blfs-flag"

set +Ee
}

_f_beyond
logout

#######################################
