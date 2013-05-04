#!/bin/bash
################################################################################
# Функция "raznost"
# Version: 0.1

raznost ()
{
local stroka1_contre=1
local stroka2_contre=1
while [ true ]
do
	local stroka1=$(sed -n "${stroka1_contre}p" "${LFS_LOG}/${1}")
	if [ ! ${stroka1} ] && [ ! $(sed -n "${stroka2_contre}p" "${LFS_LOG}/${2}") ]; then
		break
	else
		while [ true ]
		do
			local stroka2=$(sed -n "${stroka2_contre}p" "${LFS_LOG}/${2}")
			if [ "${stroka1}" = "${stroka2}" ] || [ ! ${stroka2} ]; then
				let "stroka2_contre=((${stroka2_contre} + 1))"
				break
			else
				echo ".${stroka2}"
				let "stroka2_contre=((${stroka2_contre} + 1))"
			fi
		done
	fi
	let "stroka1_contre=((${stroka1_contre} + 1))"
done
}

################################################################################
