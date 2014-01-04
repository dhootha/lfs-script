#!/bin/bash
################################################################################
# Функция "unarch"
# Version: 0.1

unarch ()
{
if [ "${PWD}" = "${BUILD_DIR}" ]; then
	rm -Rf ./*
else
	ERR_FLAG=1
	return 1
fi

echo "${name} ${version}"
date

url=$(echo ${url} | sed -e "s@_version@${version}@g")

local _archname=`basename ${url}`

#[ ! -f ${LFS_SRC}/${_archname} ] && download

echo
color-echo "EXTRACT ARCHIVE: ${_archname}" ${WHITE}
echo
tar -xpf ${LFS_SRC}/${_archname}
PACK=$(echo ${_archname} | sed -e 's@.tar.bz2@@g' -e 's@.tar.xz@@g' -e 's@.tar.gz@@g')

if [ "${#}" -ne 0 ]; then

	unset _pack_var_unarch

	for _NAME_UNARCH in ${*}
	do
		_pack_var_unarch=`pack_var "lfs.${ID}.${_NAME_UNARCH}"`
		local ${_pack_var_unarch}

		echo "${name} ${version}"
		date

		url=`echo ${url} | sed -e "s@_version@${version}@g"`
		local _archname=`basename ${url}`

#		[ ! -f ${LFS_SRC}/${_archname} ] && download

		echo
		color-echo "EXTRACT ARCHIVE: ${_archname}" ${WHITE}
		echo
		tar -xpf ${LFS_SRC}/${_archname}

		# Очистка переменных
		clear_per "${_pack_var_unarch} _pack_var_unarch"
	done
fi

}

################################################################################
