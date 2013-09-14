#!/bin/bash
################################################################################
# Функция "untar_lfs"
# Version: 0.1

untar_lfs ()
{
	local _ID=${1:0:2}
	local _archive="${_ID}_$(uname -m)_lfs.tar.bz2"
	local _log="${_LOG}/${_ID}/${_ID}_lfs.log"

	color-echo 'untar_lfs.sh' ${MAGENTA}
	color-echo "1 : ${1}" ${MAGENTA}
	color-echo "2 : ${2}" ${MAGENTA}
	color-echo "3 : ${3}" ${MAGENTA}

	if [ -n "${2}" ]; then
		if [ -f ${LFS_OUT}/${2:0:2}_$(uname -m)_lfs.tar.bz2 ] && [ $(cat ${_LOG}/${2:0:2}/${2:0:2}_flag) -eq 0 ]; then
			untar_lfs "${2}"
			untar_lfs "${1}"
		else
			scripts_tools "${2}"
			scripts_tools "${1}"
		fi
	else
		if [ -f ${LFS_OUT}/${_archive} ] && [ $(cat ${_LOG}/${_ID}/${_ID}_flag) -eq 0 ]; then
			color-echo "Распаковка: \"${_archive}\"" ${CYAN}
			echo "untar: ${1}" > "${_log}"
			date >> "${_log}"
			echo '+++++++++++++++++env+++++++++++++++++++' >> "${_log}"
			env >> "${_log}"
			echo '+++++++++++++++++++++++++++++++++++++++' >> "${_log}"
			echo '++++++++++++++++local++++++++++++++++++' >> "${_log}"
			local >> "${_log}"
			echo '+++++++++++++++++++++++++++++++++++++++' >> "${_log}"

			pushd ${LFS} > /dev/null
				tar -xf "${LFS_OUT}/${_archive}"
			popd > /dev/null

			color-echo "Создание файла: \"${_ID}-files\"" ${GREEN}
			find /tools/ | sed -e '1d' > ${_LOG}/${_ID}/${_ID}-files
			#find /tools/ -type f > ${_LOG}/${_ID}/${_ID}-files
			#find /tools/ -type d > ${_LOG}/${_ID}/${_ID}-directory

#			echo ${ERR_FLAG} > ${_LOG}/${_ID}/${_ID}_flag
			date >> "${_log}"
		else
			scripts_tools "${1}"
		fi
	fi
}

################################################################################
