#!/bin/bash
################################################################################
# Функция "md5sum_lfs"
# Version: 0.1

md5sum_lfs ()
{
	pushd ${LFS_SRC} > /dev/null 2>&1
		local _arch=${LFS_SRC}/$(url-to-file ${1:-$url})
		if [ "${2:-$md5}" ]; then
			echo "${2:-$md5}  ${_arch}" | md5sum -c
			echo "Успешно!" >> ${_log}
		else
			echo "md5sum ${_arch}"
			md5sum ${_arch}
			popd > /dev/null 2>&1
			return 1
		fi
	popd > /dev/null 2>&1
}

################################################################################
