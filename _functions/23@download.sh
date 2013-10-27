#!/bin/bash
################################################################################
# Функция "download"
# Version: 0.1

curlrc ()
{
	pushd ${LFS_SRC} > /dev/null
		color-echo "curl -C - -L -O ${1}" ${WHITE}
		curl -C - -L -O ${1}
	popd > /dev/null
}

wgetrc ()
{
	color-echo "wget -P ${LFS_SRC} -c ${1}" ${WHITE}
	wget -P ${LFS_SRC} -c ${1}
}

download ()
{
	if [ -f ${LFS_SRC}/`basename ${1:-$url}` ]; then
		basename ${1:-$url} >> ${_log}
		md5sum_lfs "${1:-$url}" "${2}"
	else
		basename ${1:-$url} >> ${_log}
		date >> ${_log}

		if [ -n "$(which wget)" ]; then
			wgetrc ${1:-$url}
		elif [ -n "$(which curl)" ]; then
			curlrc ${1:-$url}
		else
			color-echo 'Отсутствует программа для скачивания пакетов!' ${RED}
			return 1
		fi

		md5sum_lfs "${1:-$url}" "${2}"
		date >> ${_log}
	fi
}

################################################################################
