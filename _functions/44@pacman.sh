#!/bin/bash
################################################################################
# Функция "pacman_lfs"
# Version: 0.1

pacman_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

local PACKAGE_FORCE=( ${PACKAGE_FORCE[*]} )

for (( y=0; ${y} < ${#PACKAGE_FORCE[@]}; y++ ))
do
	if [ "${PACKAGE_FORCE[${y}]}" = "${_NAME}" ]; then
		local _pacman_flags="${2} --force"
		break
	else
		local _pacman_flags="${2}"
	fi
done

if [ -f ${LFS_PKG}/${_NAME}-${version}*.pkg.tar.xz ]; then
	install -d ${_LOG}/${_ID}/${1}
	( yes | pacman -U ${_pacman_flags} ${LFS_PKG}/${_NAME}-${version}*.pkg.tar.xz || ERR_FLAG=${?} ) \
		2>&1 | tee ${_LOG}/${_ID}/${1}/pacman.log
	if [ ${ERR_FLAG} -gt 0 ]; then
		color-echo "error pacman: ${1}" ${RED}
		return ${ERR_FLAG}
	fi
else
	color-echo "Отсутствует пакет pacman: ${1}" ${RED}
	ERR_FLAG=1
	return ${ERR_FLAG}
fi
}

################################################################################
