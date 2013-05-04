#!/bin/bash
################################################################################
# Функция "pack-var"
# Version: 0.1

pack_var ()
{
local OLD_IFS="$IFS"
IFS=$'\n'

local _BOOK_PACK_VAR=`echo ${1} | cut -d. -f1`
local _ID_PACK_VAR=`echo ${1} | cut -d. -f2`
local _NAME_PACK_VAR=`echo ${1} | cut -d. -f3`

#echo
#echo ${_BOOK}$'\t'${_ID}$'\t'${_NAME}
#echo ++++++++++++++++++++++++++++++++++

#for (( i=0; i < `eval echo \${#${_BOOK_PACK_VAR}_var_arr[@]}`; i++ ))
for (( i=0; i < ${#lfs_var_arr[@]}; i++ ))
do
#	pak="${_BOOK_PACK_VAR}_var_arr[${i}]"
	pak="lfs_var_arr[${i}]"

	local ${!pak}

	# Проверка пакета на включение
	if [ "${status}" -eq 0 ]; then
		# Очистка переменных
		clear_per "${!pak}"
		# Продолжаем
		continue
	fi

	IFS=';'
	for _ID_var in ${!_BOOK_PACK_VAR}
	do
		if [ "${_ID_var}" = "${_ID_PACK_VAR}" ] && \
		   [ "${_NAME_PACK_VAR}" = "${name}" ]; then
			IFS="${OLD_IFS}"
			echo "${!pak}"
			return
		fi
	done
	IFS=$'\n'

	# Очистка переменных
	clear_per "${!pak}"
done

IFS="${OLD_IFS}"

return 1
}

################################################################################
