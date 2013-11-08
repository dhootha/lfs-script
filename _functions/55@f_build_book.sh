#!/bin/bash
################################################################################
# Функция "f_build_book"
# Version: 0.1

f_build_book ()
{
# Формат: Book.Chapter.[Group | Package | All]

[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

color-echo "f_build_book: ${1}" ${MAGENTA}

# Назначаем переменные
local BOOK=`echo ${1} | cut -d. -f1`
local CHAPTER=`echo ${1} | cut -d. -f2`
local GROUP_PACKAGE_ALL=`echo ${1} | cut -d. -f3`

local LOG_DIR="${LFS_LOG}/${BOOK}/${CHAPTER}"

# clear
#if [ ! -f ${LFS_PKG}/base-core-*.pkg.tar.xz ]; then
#	rm -Rf ${LOG_DIR}
#fi
install -dv ${LOG_DIR}

# Создаем логи
echo "f_build_book: ${1}" >> "${LOG_DIR}/build.log"
date >> "${LOG_DIR}/build.log"
echo =======================env====================== >> "${LOG_DIR}/build.log"
env >> "${LOG_DIR}/build.log"
echo ======================Start===================== >> "${LOG_DIR}/build.log"

# Проверяем на необходимость собрать группу пакетов
local PACKAGE_GROUPS=( ${PACKAGE_GROUPS[*]} )
for (( i=0; ${i} < ${#PACKAGE_GROUPS[@]}; i++ ))
do
	case "${GROUP_PACKAGE_ALL}" in
		"${PACKAGE_GROUPS[${i}]}" ) local _groups_flag=1; break ;;
		'all' ) local _groups_flag=2; break ;;
		*) local _groups_flag=0 ;;
	esac
done

# Функция для обработки нескольких пакетов
_f_build_pkg_pacman_group ()
{
	local PACKAGE_NAME=`basename ${1} | cut -d. -f2`
	[ "${BOOK}" = 'lfs' ] && PACKAGE_NAME=`echo ${PACKAGE_NAME} | cut -d_ -f2`
	f_build_pkg_pacman "${BOOK}.${CHAPTER}.${PACKAGE_NAME}" "${2}"
}

# Назначаем дирикторию книги
if [ ${PACKAGE_MANAGER_FLAG} -gt 0 ] && [ "${PACKAGE_MANAGER}" != '' ]; then
	local BOOK_DIR="${LFS_PWD}/${PREFIX_LFS}/${PACKAGE_MANAGER}/${BOOK}"
else
	local BOOK_DIR="${LFS_PWD}/${PREFIX_LFS}/${BOOK}"
fi

# Собираем пакеты
case "${_groups_flag}" in
	2)
		# собираем все пакеты главы
		local PACKAGE_DIR
		for PACKAGE_DIR in ${BOOK_DIR}/${CHAPTER}_*/[6-8].*
		do
			# Собираем пакет
			_f_build_pkg_pacman_group "${PACKAGE_DIR}" "${2}" || ERR_FLAG=${?}
		done
	;;
	1)
		# собираем группу пакетов главы
		local PACKAGE_DIR
		for PACKAGE_DIR in ${BOOK_DIR}/${CHAPTER}_*/${GROUP_PACKAGE_ALL}.*
		do
			# Собираем пакет
			_f_build_pkg_pacman_group "${PACKAGE_DIR}" "${2}" || ERR_FLAG=${?}
		done
	;;
	0)
		# Собираем пакет
		f_build_pkg_pacman "${1}" "${2}" || ERR_FLAG=${?}
	;;
esac

echo ======================Finish==================== >> "${LOG_DIR}/build.log"
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${ERR_FLAG}
fi

date >> "${LOG_DIR}/build.log"
}

################################################################################
