#!/bin/bash
################################################################################
# Функция монтирования "mount_lfs"
# Version: 0.1

mount_lfs ()
{
if [ ! -f ./disk ]; then
	color-echo 'Отсутствует файл disk.' ${RED}
	return 1
else
	if [ -n "$( mount | grep ${LFS} )" ]; then
		color-echo "Остались смонтированны:
`mount | grep ${LFS}`" ${RED}
		return 1
	else
		rm -Rf ${LFS} /tools
	fi
	local _disk
	for _disk in $(cat ${LFS_PWD}/disk)
	do
		local _section=$(echo ${_disk} | cut -d: -f1)
		local _mount_point=$(echo ${_disk} | cut -d: -f2)
		local _type=$(echo ${_disk} | cut -d: -f3)

		case ${_type} in
		    'swap' )
			;;
		    ext[2-4] | 'ext4dev' )
			local _mke2fs="mkfs.${_type}"
			local _mount="mount -v -t ${_type}"
			;;
		    * )
			color-echo "Тип файловой системы не потдерживается \"${_type}\"" ${RED} & return 1
			;;
		esac

		case "${_mount_point}" in
		    'swap' )
			color-echo "Форматированние: ${_section} в ${_type}" ${CYAN}
			[ ${MOUNT_LFS_FLAG} -ne 0 ] && mkswap ${_section}
			color-echo "Монтирование: ${_section} в ${_mount_point}" ${CYAN}
			[ ${MOUNT_LFS_FLAG} -ne 0 ] && swapon -v ${_section}
			;;
		    * )
			install -dv "${LFS}${_mount_point}"
			color-echo "Форматированние: ${_section} в ${_type}" ${CYAN}
			[ ${MOUNT_LFS_FLAG} -ne 0 ] && ${_mke2fs} ${_section}
			color-echo "Монтирование: ${_section} в ${_mount_point}" ${CYAN}
			[ ${MOUNT_LFS_FLAG} -ne 0 ] && ${_mount} ${_section} "${LFS}${_mount_point}"
			;;
		esac
	done
fi

install -d ${LFS_LOG} ${LFS_SRC}
chmod -v a+wt ${LFS_SRC}
}

#####################################Z###########################################
