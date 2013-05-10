#!/bin/bash
################################################################################
# Функция "wgetrc"
# Version: 0.1

wgetrc ()
{
	if [ -f ${LFS_SRC}/$(url-to-file ${1}) ]; then
		echo $(url-to-file ${1}) >> ${_log}
		md5sum_lfs "${1}" "${2}"
	else
		echo $(url-to-file ${1}) >> ${_log}
		date >> ${_log}
		echo "wget -P ${LFS_SRC} -c ${1:-$url}"
		wget -P ${LFS_SRC} -c ${1:-$url}
		md5sum_lfs "${1}" "${2}"
		date >> ${_log}
	fi
}

################################################################################
