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

local ERR_FLAG=0

hostname ${HOSTNAME}

echo 'system_base_lfs:' >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"
env >> "${LFS_LOG}/system_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system_lfs.log"

#if [ ! -f ${LFS_PKG}/*.pkg.tar.xz ]; then
#	rm -Rf ${LFS_LOG}/06
#fi

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
        cd ${LFS_PWD}/${PREFIX}/${PACKAGE_MANAGER}/lfs/06_*/_6.05_*
else
        cd ${LFS_PWD}/${PREFIX}/lfs/06_*/_6.05_*
fi

local _i=2
while [ $(pwd | cut -d/ -f${_i}) ]
do
	local _file=$(pwd | cut -d/ -f${_i})
	local _i=`expr ${_i} + 1`
done
if [ ! -f ${LFS_PKG}/$(echo ${_file} | cut -d_ -f3)*.pkg.tar.xz ]; then
	rm -Rf ${_LOG}/06/${_file}
	makepkg --asroot --clean --log -f
	if [ ${?} -gt 0 ]; then
		color-echo "error makepkg: $(basename ${LFS_PWD}/${PREFIX}/06_*/_6.05_*)" ${RED}
		ERR_FLAG=1
	fi
	install -d ${_LOG}/06/${_file}
	mv -f *.log ${_LOG}/06/${_file}/
	rm -f *.pkg.tar.xz
fi
if [ -f ${LFS_PKG}/$(echo ${_file} | cut -d_ -f3)*.pkg.tar.xz ]; then
	yes | pacman -Uf ${LFS_PKG}/$(echo ${_file} | cut -d_ -f3)*.pkg.tar.xz
	if [ ${?} -gt 0 ]; then
		color-echo "error pacman: $(basename ${LFS_PWD}/${PREFIX}/06_*/_6.05_*)" ${RED}
		ERR_FLAG=1
	fi
fi
echo ${ERR_FLAG} > "${LFS_LOG}/system_base_lfs-flag"
}

_system_base_lfs
logout

#######################################
