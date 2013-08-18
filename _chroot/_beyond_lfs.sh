#!/bin/bash
#######################################
# _blfs
# Version: test

_beyond_lfs ()
{
local LFS_FLAG='blfs'

cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

local ERR_FLAG=0

# Назначение переменных (массивов) хроняших информацию о пакетах.
#unset lfs blfs pm
#if [ -d ./${PREFIX}/packages.conf ]; then
#	for _conf in ./${PREFIX}/packages.conf/*.conf
#	do
#		. ${_conf}
#	done
#else
#	. ./${PREFIX}/packages.conf
#fi

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
scripts_blfs '12_mc'     '--log'
scripts_blfs '04_gnupg'  '--log'
scripts_blfs '04_gnupg2' '--log'

repo-add_lfs

# Дефаултные конфиги для рута
cp -f /etc/skel/{*,.*} /root/

echo ${ERR_FLAG} > "${LFS_LOG}/blfs-flag"
}

_beyond_lfs
logout

#######################################
