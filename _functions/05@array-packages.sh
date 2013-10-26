#!/bin/bash
################################################################################
# Функция "array-packages"
# Version: 0.1

array_packages ()
{

unset lfs blfs pm lfs_var_arr blfs_var_arr pm_var_arr my_var_arr

_array_packages () {
	unset array
	source "${1}" || return ${?}
	for (( i=0; i < ${#array[@]}; i++ ))
	do
		lfs_var_arr[${#lfs_var_arr[@]}]="${array[${i}]}"
	done
}

if [ -d ${LFS_PWD}/${PREFIX_LFS}/packages.conf ]; then
	for _conf in ${LFS_PWD}/${PREFIX_LFS}/packages.conf/*.conf
	do
		_array_packages "${_conf}"
	done
else
	_array_packages "${LFS_PWD}/${PREFIX_LFS}/packages.conf"
fi

unset array

}

################################################################################
