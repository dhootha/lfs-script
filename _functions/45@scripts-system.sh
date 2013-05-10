#!/bin/bash
################################################################################
# Функция "scripts_system"
# Version: 0.1

scripts_system ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

local _ID=${1:0:2}

unset _pack_var

# clear
if [ ! -f ${LFS_PKG}/base-core-*.pkg.tar.xz ]; then
	rm -Rf ${_LOG}/${_ID}
fi
install -dv ${_LOG}/${_ID}

color-echo "scripts_system: ${1}" ${MAGENTA}

echo "scripts_system: ${1}" > "${_LOG}/${_ID}/${_ID}_lfs.log"
date >> "${_LOG}/${_ID}/${_ID}_lfs.log"
env >> "${_LOG}/${_ID}/${_ID}_lfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	local _PKGBUILD="${LFS_PWD}/${PREFIX}/${PACKAGE_MANAGER}"
else
	local _PKGBUILD="${LFS_PWD}/${PREFIX}"
fi

local pkg_lfs
for pkg_lfs in ${_PKGBUILD}/lfs/${_ID}_*/${1:1:2}[0-9][0-9]*
do
	local _dir=`basename "${pkg_lfs}"`
	local _NAME=`echo ${_dir} | cut -d_ -f2`
#	local _id=${_file:2:2}

	if [ "${_NAME}" = 'test-ld' ]; then
		pushd ${pkg_lfs}
		ERR_FLAG=${?}
		if [ ${ERR_FLAG} -gt 0 ]; then
			color-echo "error pushd: ${pkg_lfs}" ${RED}
			break
		fi
		makepkg_lfs ${_dir} ${2} || break
		popd
		continue
	fi

	# Назначаем переменные пакета
	local _pack_var=`pack_var lfs.${_ID}.${_NAME}`
	local ${_pack_var}
	name="${_NAME}"

	echo "${_ID}    ${name}    ${_dir}"
	export name version
	_url=$(echo ${url} | sed -e "s/_version/${version}/g")
	md5=${md5}
	# Проверка на наличие патчей
	for (( n=1; n <= 9; n++ ))
	do
		local urlpatch="urlpatch${n}"
		if [ "${!urlpatch}" ]; then
			_url="${_url}"$'\n'$(echo ${!urlpatch} | sed -e "s/_version/${version}/g")
			local md5patch="md5patch${n}"
			md5="${md5}"$'\n'${!md5patch}
		fi
	done
	# Проверка на udev-config
	if [ "${nconf}" ]; then
		_url="${_url}"$'\n'$(echo ${urlconf} | sed -e "s/_version/${verconf}/g")
		md5="${md5}"$'\n'${md5conf}
		export nconf verconf
	fi
	export _url md5
	pushd ${pkg_lfs}
	ERR_FLAG=${?}
	if [ ${ERR_FLAG} -gt 0 ]; then
		color-echo "error pushd: ${pkg_lfs}" ${RED}
		break
	fi
	makepkg_lfs ${_dir} ${2} || break
	pacman_lfs ${_dir} || break
	unset _url
	popd

	# Очистка переменных
	clear_per "${_pack_var}"

	[ ${ERR_FLAG} -ne 0 ] && break
done

echo ${ERR_FLAG} > ${_LOG}/${_ID}/${_ID}_flag
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${ERR_FLAG}
fi

#ldconfig

date >> "${_LOG}/${_ID}/${_ID}_lfs.log"
}

################################################################################
