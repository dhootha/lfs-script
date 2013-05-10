#!/bin/bash
################################################################################
# Функция "build_pkg_pacman_blfs"
# Version: 0.1

build_pkg_pacman_blfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

# Назначение переменных
local pkg_blfs="${1}"
local _dir=`basename "${pkg_blfs}"`
local _group=`echo ${_dir} | cut -d. -f1`
local _NAME=`echo ${_dir} | cut -d. -f2`

local depends=''
local makedepends=''

# Назначаем переменные пакета
local _pack_var=`pack_var "blfs.${_ID}.${_NAME}"`
local ${_pack_var}
name="${_NAME}"

# Проверка зависимостей пакета
_depends_pkg ()
{
clear_per "${2}"

local _c=1
while [ -n "$(echo ${1}: | cut -d: -f${_c})" ]
do
	local _pacman_pkg=''
	local _depends_scripts_blfs=''
	_depends_scripts_blfs="$(echo ${1}: | cut -d: -f${_c} | cut -d'>' -f1)"
	_pacman_pkg=`pacman -Qs $(echo ${_depends_scripts_blfs} | cut -d_ -f2) | head -n 1 | cut -d/ -f2 | cut -d' ' -f1`
	if [ "${_pacman_pkg}" != "$(echo ${_depends_scripts_blfs} | cut -d_ -f2)" ]; then
		scripts_blfs "${_depends_scripts_blfs}" '--log'
	else
		color-echo "Уже установлен пакет: $(pacman -Qs $(echo ${_depends_scripts_blfs} | cut -d_ -f2))" ${WHITE}
	fi
	(( _c++ ))
done
}

_depends_pkg "${depends}" "${_pack_var}"

# Назначаем переменные пакета
#_pack_var="$(pack_var blfs.${_ID}.${_NAME})"
local ${_pack_var}
local name="${_NAME}"

_depends_pkg "${makedepends}" "${_pack_var}"

# Назначаем переменные пакета
#_pack_var="$(pack_var blfs.${_ID}.${_NAME})"
local ${_pack_var}
local name="${_NAME}"

# Компоновка переменной зависимостей пакета
local _depends=''
local _c=1
while [ -n "$(echo ${depends}: | cut -d: -f${_c})" ]
do
	if [ "${_c}" -gt 1 ]
	then    _depends="${_depends} $(echo ${depends}: | cut -d: -f${_c} | cut -d_ -f2)"
	else    _depends="$(echo ${depends}: | cut -d: -f${_c} | cut -d_ -f2)"
	fi
	(( _c++ ))
done

# Компоновка переменной зависимостей сборки пакета
local _makedepends=''
local _c=1
while [ -n "$(echo ${makedepends}: | cut -d: -f${_c})" ]
do
        if [ "${_c}" -gt 1 ]
        then    _makedepends="${_makedepends} $(echo ${makedepends}: | cut -d: -f${_c} | cut -d_ -f2)"
        else    _makedepends="$(echo ${makedepends}: | cut -d: -f${_c} | cut -d_ -f2)"
        fi
        (( _c++ ))
done

local _url=$(echo ${url} | sed -e "s/_version/${version}/g")
local md5=${md5}

# Проверка на наличие патчей
for (( n=1; n <= 9; n++ ))
do
	local urlpatch="urlpatch${n}"
	if [ -n "${!urlpatch}" ]; then
		_urlpatch=`echo ${!urlpatch} | sed -e "s/_version/${version}/g"`
		_url="${_url}"$'\n'${_urlpatch}
		local md5patch="md5patch${n}"
		if [ -n "${!md5patch}" ]; then
			md5="${md5}"$'\n'${!md5patch}
		else
			local _md5patch="$(curl ${_urlpatch} | md5sum | cut -d' ' -f1)"
			md5="${md5}"$'\n'"${_md5patch}"
			color-echo "Для патча `basename ${_urlpatch}` определена сумма: ${_md5patch}" ${WHITE}
			read
		fi
	fi
	unset ${urlpatch} ${md5patch} _urlpatch _md5patch
done

# Установка переменной группы пакета
for (( i=0; i < ${#PACKAGE_GROUPS[@]}; i++ ))
do
	if [ "${_group}" == "${PACKAGE_GROUPS[${i}]}" ]
	then	export _groups="${_group}"; break
	else	unset _groups
	fi
done

export name version _url md5 _depends _makedepends

pushd ${pkg_blfs} || error-popd
	if [ -n "${md5}" ]; then
		makepkg_lfs ${_dir} ${2}
	else
		makepkg --asroot -g
	fi
	pacman_lfs ${_dir}
popd

clear_per ${_pack_var}

unset name version _url md5 _depends _makedepends
}

################################################################################
