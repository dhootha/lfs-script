#!/bin/bash
################################################################################
# Функция "makepkg_lfs"
# Version: 0.1

makepkg_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

echo ++++++++++makepkg+++++++++++
echo ${_url}
echo ${md5}
echo ++++++++++++++++++++++++++++

if [ ! -f ${LFS_PKG}/${_name}-${version}*.pkg.tar.xz ]; then
	rm -Rf ${_LOG}/${_ID}/${_dir}
	rm -Rf ./{pkg,src} *.log
	makepkg --asroot --clean ${1} -f || ERR_FLAG=${?}
	if [ ${ERR_FLAG} -gt 0 ]; then
		color-echo "error makepkg: ${_dir}" ${RED}
		return ${ERR_FLAG}
	fi
	install -d ${_LOG}/${_ID}/${_dir}
	mv -f *.log ${_LOG}/${_ID}/${_dir}/
	rm -f *.pkg.tar.xz
else
	color-echo "Не требуется makepkg: ${_dir}" ${WHITE}
fi
}

################################################################################
