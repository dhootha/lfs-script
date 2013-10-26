#!/bin/bash
#######################################
# system_base_lfs
# Version: test

_system_base_lfs ()
{
cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local LFS_FLAG='system-base-lfs'

local ERR_FLAG=0

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

hostname ${HOSTNAME}

echo 'system_base_lfs:' >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"
env >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
        cd ${LFS_PWD}/${PREFIX_LFS}/${PACKAGE_MANAGER}/lfs/06_*/_6.05_*
else
        cd ${LFS_PWD}/${PREFIX_LFS}/lfs/06_*/_6.05_*
fi

local _dir=`basename $PWD`
local _NAME=`echo ${_dir} | cut -d_ -f3`
local _ID='06'

makepkg_lfs ${_dir} '--log'
pacman_lfs ${_dir}

echo ${ERR_FLAG} > "${LFS_LOG}/system_base_lfs-flag"

set +Ee
}

_system_base_lfs
logout

#######################################
