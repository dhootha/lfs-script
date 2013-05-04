#!/bin/bash
################################################################################
# Функция "pacman_lfs"
# Version: 0.1

pacman_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

if [ -f ${LFS_PKG}/${_name}-${version}*.pkg.tar.xz ]; then
	yes | pacman -Uf ${LFS_PKG}/${_name}-${version}*.pkg.tar.xz || ERR_FLAG=${?}
	if [ ${ERR_FLAG} -gt 0 ]; then
		color-echo "error pacman: ${pkg_blfs}" ${RED}
		return ${ERR_FLAG}
	fi
else
	color-echo "Отсутствует пакет pacman: ${_dir}" ${RED}
	ERR_FLAG=1
	return ${ERR_FLAG}
fi
}

################################################################################
