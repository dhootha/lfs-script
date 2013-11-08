#!/bin/bash
#######################################
# f_system_base
# Version: test

f_system_base ()
{
cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local LFS_FLAG='f_system-base'

local ERR_FLAG=0

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

hostname ${HOSTNAME}

echo 'f_system_base:' >> "${LFS_LOG}/system.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system.log"
env >> "${LFS_LOG}/system.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/system.log"

f_build_book 'lfs.06.base-core' '--log'

echo ${ERR_FLAG} > "${LFS_LOG}/system_base-flag"

set +Ee
}

f_system_base
logout

#######################################
