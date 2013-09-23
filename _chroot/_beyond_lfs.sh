#!/bin/bash
#######################################
# _blfs
# Version: test

_beyond_lfs ()
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

array_packages || ERR_FLAG=${?}

#hostname ${HOSTNAME}

echo 'blfs:' >> "${LFS_LOG}/blfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/blfs.log"
env >> "${LFS_LOG}/blfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/blfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	scripts_blfs "pm_${PACKAGE_MANAGER}" '--log'
fi
[ -d /tools ] && rm -Rf /tools
scripts_blfs 'my_base'   '--log'
scripts_blfs '03_base'   '--log'
scripts_blfs '12_base'   '--log'
#scripts_blfs '14_base'   '--log'
#scripts_blfs '04_gnupg'  '--log'
#scripts_blfs '04_gnupg2' '--log'

repo-add_lfs

# Дефаултные конфиги для рута
cp -rf `find /etc/skel/ | sed -e '1d'` /root/

echo ${ERR_FLAG} > "${LFS_LOG}/blfs-flag"

set +Ee
}

_beyond_lfs
logout

#######################################
