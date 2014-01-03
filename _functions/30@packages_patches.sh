#!/bin/bash
################################################################################
# Функция "packages_patches"
# Version: 0.1

f_packages_patches ()
{
local LFS_FLAG='packages_patches'

if [ "${PACKAGES_PATCHES_LFS_FLAG}" -eq 0 ]; then
        return 0
fi

color-echo "packages_patches" ${YELLOW}

local _log="${LFS_LOG}/packages_patches.log"
:> ${_log}

for pack in `${LFS_PHP}/packages_patches.php 'http://www.linuxfromscratch.org/lfs/view/development/chapter03/packages.html'`
do
	# name ; version ; home ; url ; md5
	echo ${pack}
	local name=`echo ${pack} | cut -d\; -f1`
	local version=`echo ${pack} | cut -d\; -f2`
	local home=`echo ${pack} | cut -d\; -f3`
	local url=`echo ${pack} | cut -d\; -f4`
	local md5=`echo ${pack} | cut -d\; -f5`

	grep -A3 "^name=${name}$" ${LFS_PWD}/${PREFIX_LFS}/packages.conf/*.conf
	read
done
}

################################################################################
