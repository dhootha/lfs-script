#!/bin/bash
################################################################################
# Функция "f_makepkg"
# Version: 0.1

f_makepkg ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

echo ++++++++++makepkg+++++++++++
echo name=\'${name}\'
echo version=\'${version}\'
echo _url=\'${_url}\'
echo md5=\'${md5}\'
echo _depends=\'${_depends}\'
echo _makedepends=\'${_makedepends}\'
echo ++++++++++++++++++++++++++++

if [ ! -f ${LFS_PKG}/${BOOK}/${name}-${version}*.pkg.tar.xz ]; then
	rm -Rf ${LOG_DIR}/${1}
	rm -Rf ./{pkg,src} *.log
	makepkg --asroot --clean ${2} -f || ERR_FLAG=${?}
	if [ ${ERR_FLAG} -gt 0 ]; then
		color-echo "error makepkg: ${1}" ${RED}
		return ${ERR_FLAG}
	fi
	mv ${LFS_PKG}/${name}-${version}*.pkg.tar.xz ${LFS_PKG}/${BOOK}/
	install -d ${LOG_DIR}/${1}
	mv -f *.log ${LOG_DIR}/${1}/
	rm -f *.pkg.tar.xz
else
	color-echo "Не требуется makepkg: ${1}" ${WHITE}
fi
}

################################################################################
