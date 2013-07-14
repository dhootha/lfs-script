#!/bin/bash
################################################################################
# Функция "md5sum_lfs"
# Version: 0.1

md5sum_lfs ()
{
	pushd ${LFS_SRC} > /dev/null 2>&1
		local _arch=${LFS_SRC}/`url-to-file ${1:-$url}`
		if [ -n "${2:-$md5}" ]; then
			echo "${2:-$md5}  ${_arch}" | md5sum -c || ERR_FLAG=${?}
			if [ "${ERR_FLAG}" -gt 0 ]; then
				color-echo "md5 file `url-to-file ${1:-$url}`: `md5sum ${_arch} | cut -d' ' -f1`" ${RED}
				color-echo "Ожидался: ${2:-$md5}" ${RED}
				return ${ERR_FLAG}
			else
				echo "Успешно!" >> ${_log}
			fi
		else
			echo "md5sum ${_arch}"
			md5sum ${_arch}
			popd > /dev/null 2>&1
			return 1
		fi
	popd > /dev/null 2>&1
}

################################################################################
