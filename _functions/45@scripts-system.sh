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
#df >> "${_LOG}/${1:0:2}/${1:0:2}_lfs.log"
#df -a >> "${_LOG}/${1:0:2}/${1:0:2}_lfs.log"

if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	local _PKGBUILD="${LFS_PWD}/${PREFIX}/${PACKAGE_MANAGER}"
else
	local _PKGBUILD="${LFS_PWD}/${PREFIX}"
fi

local pkg_lfs
for pkg_lfs in ${_PKGBUILD}/lfs/${_ID}_*/${1:1:2}[0-9][0-9]*
do
	local _file=`basename "${pkg_lfs}"`
	local _NAME=`echo ${_file} | cut -d_ -f2`
#	local _id=${_file:2:2}

	if [ "${_NAME}" = 'test-ld' ]; then
		pushd ${pkg_lfs}
		ERR_FLAG=${?}
		if [ ${ERR_FLAG} -gt 0 ]; then
			color-echo "error pushd: ${pkg_lfs}" ${RED}
			break
		fi
		if [ ! -f ${LFS_PKG}/$(echo ${_file} | cut -d_ -f2)-${version}*.pkg.tar.xz ]; then
			makepkg_lfs ${2} || break
#			rm -Rf ${_LOG}/${_ID}/${_file}
#			rm -Rf ./{pkg,src} *.log
#			makepkg --asroot --clean ${2} -f
#			ERR_FLAG=${?}
#			if [ ${ERR_FLAG} -ne 0 ]; then
#				color-echo "error makepkg: ${_file}" ${RED}
#				break
#			fi
#			install -d ${_LOG}/${_ID}/${_file}
#			mv -f *.log ${_LOG}/${_ID}/${_file}/
#			rm -f *.pkg.tar.xz
		fi
		popd
		continue
	fi

#	for (( i=0; i <= ${#lfs[@]} - 1; i++ ))
#	do
#		pak="lfs[${i}]"
#		local ${!pak}

#		if [ "${status}" -eq 0 ]; then
			# Очистка переменных
#			clear_per "${!pak}"
			# Продолжаем
#			continue
#		fi

	# Назначаем переменные пакета
	_pack_var=`pack_var lfs.${_ID}.${_NAME}`
	local ${_pack_var}

#		_paket="lfs${1:0:2}"
#		if [ "${!_paket:0:2}" = "${_id}" ]; then
	echo "${_ID}    ${name}    ${_file}"
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
	if [ ! -f ${LFS_PKG}/$(echo ${_file} | cut -d_ -f2)-${version}*.pkg.tar.xz ]; then
		makepkg_lfs ${2} || break
#		rm -Rf ${_LOG}/${_ID}/${_file}
#		rm -Rf ./{pkg,src} *.log
#		makepkg --asroot --clean ${2} -f
#		ERR_FLAG=${?}
#		if [ ${ERR_FLAG} -ne 0 ]; then
#			color-echo "error makepkg: ${_file}" ${RED}
#			break
#		fi
#		install -d ${_LOG}/${_ID}/${_file}
#		mv -f *.log ${_LOG}/${_ID}/${_file}/
#		rm -f *.pkg.tar.xz
	fi
	if [ -f ${LFS_PKG}/$(echo ${_file} | cut -d_ -f2)-${version}*.pkg.tar.xz ]; then
		pacman_lfs || break
#		yes | pacman -Uf ${LFS_PKG}/$(echo ${_file} | cut -d_ -f2)-${version}*.pkg.tar.xz
#		ERR_FLAG=${?}
#		if [ ${ERR_FLAG} -gt 0 ]; then
#			color-echo "error pacman: ${pkg_lfs}" ${RED}
#			break
#		fi
	fi
	unset _url
	popd
#		fi

	# Очистка переменных
	clear_per "${_pack_var}"
#	done
	[ ${ERR_FLAG} -ne 0 ] && break
done

echo ${ERR_FLAG} > ${_LOG}/${_ID}/${_ID}_flag
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${ERR_FLAG}
fi

ldconfig

date >> "${_LOG}/${_ID}/${_ID}_lfs.log"
}

################################################################################
