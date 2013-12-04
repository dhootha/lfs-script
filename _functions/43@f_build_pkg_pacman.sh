#!/bin/bash
################################################################################
# Функция "f_build_pkg_pacman"
# Version: 0.1

f_build_pkg_pacman ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

echo ${1}

# Назначение переменных
local BOOK=`echo ${1} | cut -d. -f1`
local CHAPTER=`echo ${1} | cut -d. -f2`
local PACKAGE_NAME=`echo ${1} | cut -d. -f3`

local LOG_DIR="${LFS_LOG}/${BOOK}/${CHAPTER}"
install -d ${LOG_DIR}

if [ -n "$(pacman -Q ${PACKAGE_NAME})" ]; then
#if [ -n "$(grep -rl "name='${PACKAGE_NAME}'" ${LFS_LOG})" ]; then
	color-echo "Уже установлен пакет: `pacman -Q ${PACKAGE_NAME}`" ${WHITE}
	return 0
fi

# Назначаем дирикторию книги
if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	local BOOK_DIR="${LFS_PWD}/${PREFIX_LFS}/${PACKAGE_MANAGER}/${BOOK}"
else
	local BOOK_DIR="${LFS_PWD}/${PREFIX_LFS}/${BOOK}"
fi

# Назначение директории пакета
case "${BOOK}" in
#	'blfs') local PACKAGE_DIR=${BOOK_DIR}/${CHAPTER}_*/*.${PACKAGE_NAME} ;;
	'lfs') local PACKAGE_DIR=${BOOK_DIR}/${CHAPTER}_*/[6-8].[0-9][0-9]_${PACKAGE_NAME} ;;
	*) local PACKAGE_DIR=${BOOK_DIR}/${CHAPTER}_*/*.${PACKAGE_NAME} ;;
esac

local _group=`basename ${PACKAGE_DIR} | cut -d. -f1`

local depends=''
local makedepends=''
local blfs_bootscripts=''

# Назначаем переменные пакета
local _pack_var=`pack_var "${1}"`
local ${_pack_var}
local name="${PACKAGE_NAME}"

# Функция для проверки зависимостей пакета
_f_depends_pkg ()
{
#clear_per "${2}"

local _c=1
while [ -n "$(echo ${1}: | cut -d: -f${_c})" ]
do
	clear_per "${2}"
	f_build_pkg_pacman `echo ${1}: | cut -d: -f${_c} | cut -d'>' -f1` '--log'
	(( _c++ ))
done
}

# Проверяем зависимые пакеты для установки
_f_depends_pkg "${depends}" "${_pack_var}"

# Назначаем переменные пакета
local ${_pack_var}
local name="${PACKAGE_NAME}"

# Проверяем зависимые пакеты для сборки
_f_depends_pkg "${makedepends}" "${_pack_var}"

# Назначаем переменные пакета
local ${_pack_var}
local name="${PACKAGE_NAME}"

# Компоновка переменной зависимостей пакета
local _depends=''
local _c=1
while [ -n "$(echo ${depends}: | cut -d: -f${_c})" ]
do
	if [ "${_c}" -gt 1 ]
	then    _depends="${_depends} $(echo ${depends}: | cut -d: -f${_c} | cut -d. -f3)"
	else    _depends="$(echo ${depends}: | cut -d: -f${_c} | cut -d. -f3)"
	fi
	(( _c++ ))
done

# Компоновка переменной зависимостей сборки пакета
local _makedepends=''
local _c=1
while [ -n "$(echo ${makedepends}: | cut -d: -f${_c})" ]
do
        if [ "${_c}" -gt 1 ]
        then    _makedepends="${_makedepends} $(echo ${makedepends}: | cut -d: -f${_c} | cut -d. -f3)"
        else    _makedepends="$(echo ${makedepends}: | cut -d: -f${_c} | cut -d. -f3)"
        fi
        (( _c++ ))
done

if [ "$url" != 'NONE' ] && [ -n "${url}" ]; then
	local _url=`echo ${url} | sed -e "s/_version/${version}/g"`
else
	local _url=''
fi

# Проверка на наличие патчей
for (( n=1; n <= 9; n++ ))
do
	local urlpatch="urlpatch${n}"
	if [ -n "${!urlpatch}" ]; then
		_urlpatch=`echo ${!urlpatch} | sed -e "s/_version/${version}/g"`
		_url="${_url}"$'\n'"${_urlpatch}"
		local md5patch="md5patch${n}"
		if [ -n "${!md5patch}" ]; then
			md5="${md5}"$'\n'"${!md5patch}"
		else
			local _md5patch="$(curl ${_urlpatch} | md5sum | cut -d' ' -f1)"
			md5="${md5}"$'\n'"${_md5patch}"
			color-echo "Для патча `basename ${_urlpatch}` определена сумма: ${_md5patch}" ${WHITE}
			read
		fi
	fi
	unset ${urlpatch} ${md5patch} _urlpatch _md5patch
done

# Проверка на udev-config
if [ "${nconf}" ]; then
	_url="${_url}"$'\n'$(echo ${urlconf} | sed -e "s/_version/${verconf}/g")
	md5="${md5}"$'\n'${md5conf}
	export nconf verconf
fi

# Установка переменной группы пакета
for (( i=0; i < ${#PACKAGE_GROUPS[@]}; i++ ))
do
	if [ "${_group}" == "${PACKAGE_GROUPS[${i}]}" ]
	then	export _groups="${_group}"; break
	else	unset _groups
	fi
done

# Проверка на необходимость установки blfs-bootscripts
if [ "${blfs_bootscripts}" = '02' ]; then
	for blfs_bootscripts_per in `pack_var blfs.02.blfs-bootscripts`
	do
		case `echo ${blfs_bootscripts_per} | cut -d= -f1` in
			'md5')
				local _md5blfs="$(echo ${blfs_bootscripts_per} | cut -d= -f2)"
				[ -n "${_md5blfs}" ] && \
					md5="${md5}"$'\n'"${_md5blfs}" || \
					unset md5
			;;
			'url') 
				local _urlblfs="$(echo ${blfs_bootscripts_per} | cut -d= -f2)"
				_url="${_url}"$'\n'"${_urlblfs}"
			;;
		esac
	done
fi

export name version _url md5 _depends _makedepends

pushd ${PACKAGE_DIR} || error-popd
	if [ -n "${md5}" ]; then
		[ "${_url}" = 'NONE' ] && export _url=''
		[ "${md5}" = 'NONE' ] && export md5=''
		# Сборка пакета
		f_makepkg ${PACKAGE_NAME} ${2}
	else
		# Подсчет md5 суммы
		makepkg --asroot -g
	fi
	[ "${name}" = 'test-ld' ] && return 0
	# Установка пакета
	f_pacman ${PACKAGE_NAME}
popd

# Очистка переменных
clear_per "${_pack_var}"
unset name version _url md5 _depends _makedepends
}

################################################################################
