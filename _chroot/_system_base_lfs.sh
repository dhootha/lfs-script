#!/bin/bash
#######################################
# system_base_lfs
# Version: test

_system_base_lfs ()
{
local LFS_FLAG='system-base-lfs'

cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local ERR_FLAG=0

hostname ${HOSTNAME}

echo 'system_base_lfs:' >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"
env >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"

ldconfig

#if [ ! -f ${LFS_PKG}/*.pkg.tar.xz ]; then
#	rm -Rf ${LFS_LOG}/06
#fi

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
        cd ${LFS_PWD}/${PREFIX}/${PACKAGE_MANAGER}/lfs/06_*/_6.05_*
else
        cd ${LFS_PWD}/${PREFIX}/lfs/06_*/_6.05_*
fi

local _dir=`basename $PWD`
local _NAME=`echo ${_dir} | cut -d_ -f3`
local _ID='06'

makepkg_lfs ${_dir} '--log'
pacman_lfs ${_dir}

echo ${ERR_FLAG} > "${LFS_LOG}/system_base_lfs-flag"
}

_system_base_lfs
logout

#######################################
