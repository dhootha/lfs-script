#!/bin/bash
################################################################################
# Функция "f_pacman"
# Version: 0.1

f_pacman ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

local PACKAGE_FORCE=( ${PACKAGE_FORCE[*]} )

for (( y=0; ${y} < ${#PACKAGE_FORCE[@]}; y++ ))
do
	if [ "${PACKAGE_FORCE[${y}]}" = "${name}" ]; then
		local _pacman_flags="${2} --force"
		break
	else
		local _pacman_flags="${2}"
	fi
done

if [ -f ${LFS_PKG}/${name}-${version}*.pkg.tar.xz ]; then
	install -d ${LOG_DIR}/${1}
	yes | pacman -U ${_pacman_flags} ${LFS_PKG}/${name}-${version}*.pkg.tar.xz || ERR_FLAG=${?}
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
