#!/bin/bash
################################################################################
# Функция "md5sum_lfs"
# Version: 0.1

url-to-file ()
{
	local c=1
	while [ true ]
	do
		local per=$(echo ${1:-$url} | cut -d/ -f${c})
		case "${per}" in
			'http:' | 'https:' | 'ftp:' ) let "c += 2" ;;
			* )
				if [ "${per}" ]; then
					let "c += 1"
				else
					break
				fi
				;;
		esac
	done
	echo $(echo ${1:-$url} | cut -d/ -f$(($c - 1)))
}

################################################################################
