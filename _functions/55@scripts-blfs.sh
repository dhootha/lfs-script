#!/bin/bash
################################################################################
# Функция "scripts_blfs"
# Version: 0.1

scripts_blfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

local _ID="${1:0:2}"

# clear
if [ ! -f ${LFS_PKG}/base-core-*.pkg.tar.xz ]; then
	rm -Rf ${_LOG}/${_ID}
fi
install -dv ${_LOG}/${_ID}

color-echo "scripts_blfs: ${1}" ${MAGENTA}

echo "scripts_blfs: ${1}" >> "${_LOG}/${_ID}/${_ID}_blfs.log"
date >> "${_LOG}/${_ID}/${_ID}_blfs.log"
env >> "${_LOG}/${_ID}/${_ID}_blfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	local _PKGBUILD="${LFS_PWD}/${PREFIX}/${PACKAGE_MANAGER}/blfs"
else
	local _PKGBUILD="${LFS_PWD}/${PREFIX}/blfs"
fi

# Проверяем на необходимость собрать группу пакетов
local PACKAGE_GROUPS=( ${PACKAGE_GROUPS[*]} )
for (( i=0; ${i} < ${#PACKAGE_GROUPS[@]}; i++ ))
do
	if [ "${PACKAGE_GROUPS[${i}]}" = "${1:3}" ]; then
		# если собираем группу пакетов
		local _groups_flag=1
		break
	else
		# если собираем пакет
		local _groups_flag=0
	fi
done

if [ "${_groups_flag}" -gt 0 ]; then
	# собираем группу пакетов
	local pkg_blfs
	for pkg_blfs in ${_PKGBUILD}/${_ID}_*/${1:3}.*
	do
		# Собираем пакет
		build_pkg_pacman_blfs ${pkg_blfs} ${2} || ERR_FLAG=${?}
	done
else
	# Собираем пакет
	build_pkg_pacman_blfs ${_PKGBUILD}/${_ID}_*/$(basename ${_PKGBUILD}/${_ID}_*/*.${1:3}) ${2} || ERR_FLAG=${?}
fi

echo ${ERR_FLAG} > ${_LOG}/${_ID}/${_ID}_flag
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${ERR_FLAG}
fi

date >> "${_LOG}/${_ID}/${_ID}_blfs.log"
}

################################################################################
