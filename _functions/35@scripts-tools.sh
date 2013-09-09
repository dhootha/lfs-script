#!/bin/bash
################################################################################
# Функция "scripts_tools"
# Version: 0.1

scripts_tools ()
{
local _ID=${1:0:2}
local _archive="${_ID}_$(uname -m)_lfs.tar.bz2"

# clear
rm -Rf ${_LOG}/${_ID} ${LFS_SRC}/${_archive}
install -dv ${_LOG}/${_ID}

color-echo 'scripts-tools.sh' ${MAGENTA}
color-echo "1 : ${1}" ${MAGENTA}
color-echo "2 : ${2}" ${MAGENTA}
color-echo "3 : ${3}" ${MAGENTA}

# Проверка зависимостей
if [ -n "${2}" ]; then
	untar_lfs "${2}"
#	[ ${ERR_FLAG} -gt 0 ] && return ${ERR_FLAG}
fi

echo "scripts_build: ${1}" >> "${_LOG}/${_ID}/${_ID}_lfs.log"
date >> "${_LOG}/${_ID}/${_ID}_lfs.log"
echo '+++++++++++++++++env+++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"
env >> "${_LOG}/${_ID}/${_ID}_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"
echo '++++++++++++++++local++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"
local >> "${_LOG}/${_ID}/${_ID}_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"

unset _pack_var

local _script
for _script in ${LFS_PWD}/${PREFIX}/tools/${_ID}_*/${_ID}.[0-9][0-9]*.sh
do
	local _file=`basename "${_script}"`
	local _NAME=`echo ${_file} | cut -d_ -f2 | cut -d. -f1`

	local _log="${_LOG}/${_ID}/${_file}.log"
	if [[ -f ${_log} ]]; then
		rm -vf ${_log}
	fi
	local logpipe=$(mktemp -u "${_LOG}/${_ID}/logpipe.XXXXXXXX")
	mkfifo "${logpipe}"
	tee "${_log}" < "${logpipe}" &
	local teepid=${!}

	# Назначаем переменные пакета
	_pack_var=`pack_var "lfs.${_ID}.${_NAME}"`
	local ${_pack_var}
	local name="${_NAME}"

	while [ true ]
	do
		echo "${_ID}    ${name}    ${_file}"
		. ${_script} || ERR_FLAG=${?}
		if [ ${ERR_FLAG} -ne 0 ]; then
			color-echo "ERROR: ${_file}" ${RED}
			color-echo "Повторить - r" ${YELLOW}
			color-echo "Пропустить - c" ${YELLOW}
			color-echo "Остановить - x" ${YELLOW}
			local _flag=''
			read _flag
			case ${_flag} in
				'r')
					ERR_FLAG=0
					popd
					[ -d ${BUILD_DIR} ] && rm -Rf ${BUILD_DIR}/*
					echo '+++++++++++++++++env+++++++++++++++++++'
					env
					echo '+++++++++++++++++++++++++++++++++++++++'
					echo '++++++++++++++++local++++++++++++++++++'
					local
					echo '+++++++++++++++++++++++++++++++++++++++'
					local _flag=''
					continue
				;;
				'c')
					popd
					ERR_FLAG=0
					local _flag=''
				;;
				*)	return ${ERR_FLAG} ;;
			esac
		fi
		break
	done &>"${logpipe}"

	[ ${ERR_FLAG} -ne 0 ] && break
	[ -d ${BUILD_DIR} ] && rm -Rf ${BUILD_DIR}/*

	wait ${teepid}
	rm "${logpipe}"

	clear_per "${_pack_var}"

	date >> ${_log}
done

echo ${ERR_FLAG} > ${_LOG}/${_ID}/${_ID}_flag
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${?}
fi

# clear
strip --strip-debug /tools/lib/* || true
strip --strip-unneeded /tools/{,s}bin/* || true
rm -rf /tools/{,share}/{info,man,doc}

color-echo "Создание файла: \"${_ID}-files\"" ${GREEN}
find /tools/ | sed -e '1d' > ${_LOG}/${_ID}/${_ID}-files
#find /tools/ -not -type d > ${_LOG}/${_ID}/${_ID}-files
#find /tools/ -type d > ${_LOG}/${_ID}/${_ID}-directory
#find /tools/ -type f > ${_LOG}/${_ID}/${_ID}-files
#find /tools/ -type d > ${_LOG}/${_ID}/${_ID}-directory

if [ "${_ID}" != '05' ]; then
	color-echo 'Получаем переменную: "_raznost"' ${GREEN}
	local _files=`diff -n "${_LOG}/05/05-files" "${_LOG}/${_ID}/${_ID}-files" | grep '^/tools'`
else
	local _files=`cat ${_LOG}/${_ID}/${_ID}-files`
fi

pushd ${LFS_OUT}
	color-echo "Создание архива: \"${_archive}\"" ${GREEN}
	tar -cjf ${_archive} ${_files}
	bzip2 -t ${_archive}
popd

date >> "${_LOG}/${_ID}/${_ID}_lfs.log"
}

################################################################################
