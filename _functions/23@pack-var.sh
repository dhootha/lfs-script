#!/bin/bash
################################################################################
# Функция "pack-var"
# Version: 0.1

pack_var ()
{
local _BOOK_PACK_VAR=`echo ${1} | cut -d. -f1`
local _ID_PACK_VAR=`echo ${1} | cut -d. -f2`
local _NAME_PACK_VAR=`echo ${1} | cut -d. -f3`

for (( i=0; i < ${#lfs_var_arr[@]}; i++ ))
do
	pak="lfs_var_arr[${i}]"

	local ${!pak}

	# Проверка пакета на включение
	if [ "${status}" -eq 0 ]; then
		# Очистка переменных
		clear_per "${!pak}"
		# Продолжаем
		continue
	fi

	local OLD_IFS="$IFS"
	IFS=';'
	for _ID_var in ${!_BOOK_PACK_VAR}
	do
		for _NAME_var in ${name}
		do
			if [ "${_ID_var}" = "${_ID_PACK_VAR}" ] && \
			   [ "${_NAME_var}" = "${_NAME_PACK_VAR}" ]; then
				IFS="${OLD_IFS}"
				echo "${!pak}"
				return 0
			fi
		done
	done
	IFS="${OLD_IFS}"

	# Очистка переменных
	clear_per "${!pak}"
done

return 1
}

################################################################################
