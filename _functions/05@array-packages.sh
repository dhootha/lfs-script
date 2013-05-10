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

if [ -d ${LFS_PWD}/${PREFIX}/packages.conf ]; then
	for _conf in ${LFS_PWD}/${PREFIX}/packages.conf/*.conf
	do
		_array_packages "${_conf}"
	done
else
	_array_packages "${LFS_PWD}/${PREFIX}/packages.conf"
fi

unset array


#local _array
#for _array in ${*}
#do
#	for (( i=0; i < ${#array[@]}; i++ ))
#	do
#		export ${_array}[\${#${_array}[@]}]="${array[${i}]}"
#	done

#	case ${_array} in
#		'blfs')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				blfs[${#blfs[@]}]="${array[${i}]}"
#			done
#		;;
#		'lfs')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				lfs[${#lfs[@]}]="${array[${i}]}"
#			done
#		;;
#		'pm')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				pm[${#pm[@]}]="${array[${i}]}"
#			done
#		;;
#		'blfs_var_arr')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				blfs_var_arr[${#blfs_var_arr[@]}]="${array[${i}]}"
#			done
#		;;
#		'lfs_var_arr')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				lfs_var_arr[${#lfs_var_arr[@]}]="${array[${i}]}"
#			done
#		;;
#		'pm_var_arr')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				pm_var_arr[${#pm_var_arr[@]}]="${array[${i}]}"
#			done
#		;;
#		'my_var_arr')
#			for (( i=0; i < ${#array[@]}; i++ ))
#			do
#				my_var_arr[${#my_var_arr[@]}]="${array[${i}]}"
#			done
#		;;
#	esac
#done
}

################################################################################
