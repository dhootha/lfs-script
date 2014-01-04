#!/bin/bash
################################################################################
# Функция "scripts_tools"
# Version: 0.1

scripts_tools ()
{
color-echo 'scripts-tools.sh' ${MAGENTA}
color-echo "1: ${1}" ${MAGENTA}
color-echo "2: ${2}" ${MAGENTA}
color-echo "3: ${3}" ${MAGENTA}

local ID=${1:0:2}
[ "${ID}" = 0[5,6,7] ] && \
local BOOK='lfs' || \
local BOOK='notlfs'
local archive="${ID}_$(uname -m)_lfs.tar.bz2"
local LOG_FILE="${LOG_DIR}/${ID}/${ID}_lfs.log"

# Проверка зависимостей
if [ -n "${2}" ]; then
	scripts_tools "${2}"
fi

if [ -f ${LFS_OUT}/${archive} ] && [ $(cat ${LOG_DIR}/${ID}/${ID}_flag) -eq 0 ]; then
	color-echo "untar: ${1}" ${MAGENTA}
	echo "untar: ${1}" >> "${LOG_FILE}"
	date >> "${LOG_FILE}"
	echo '+++++++++++++++++env+++++++++++++++++++' >> "${LOG_FILE}"
	env >> "${LOG_FILE}"
	echo '+++++++++++++++++++++++++++++++++++++++' >> "${LOG_FILE}"
	echo '++++++++++++++++local++++++++++++++++++' >> "${LOG_FILE}"
	local >> "${LOG_FILE}"
	echo '+++++++++++++++++++++++++++++++++++++++' >> "${LOG_FILE}"

	color-echo "Проверка архива: \"${archive}\"" ${CYAN}
	bzip2 -t "${LFS_OUT}/${archive}"

	color-echo "Распаковка архива: \"${archive}\"" ${CYAN}
	pushd ${LFS} > /dev/null
		tar -xf "${LFS_OUT}/${archive}" || ERR_FLAG=${?}
	popd > /dev/null

	color-echo "Создание файла: \"${ID}-files\"" ${GREEN}
	find /tools/ | sed -e '1d' > ${LOG_DIR}/${ID}/${ID}-files

	echo ${ERR_FLAG} > ${LOG_DIR}/${ID}/${ID}_flag
	if [ ${ERR_FLAG} -eq 0 ]; then
		color-echo "OK: ${1}" ${GREEN}
	else
		color-echo "ERROR: ${1}" ${RED} & return ${?}
	fi

	date >> "${LOG_FILE}"

	return ${ERR_FLAG}
fi

# clear log
rm -Rf ${LOG_DIR}/${ID} ${LFS_SRC}/${archive}
install -dv ${LOG_DIR}/${ID}

color-echo "scripts_build: ${1}" ${MAGENTA}
echo "scripts_build: ${1}" >> ${LOG_FILE}
date >> ${LOG_FILE}
echo '+++++++++++++++++env+++++++++++++++++++' >> ${LOG_FILE}
env >> ${LOG_FILE}
echo '+++++++++++++++++++++++++++++++++++++++' >> ${LOG_FILE}
echo '++++++++++++++++local++++++++++++++++++' >> ${LOG_FILE}
local >> ${LOG_FILE}
echo '+++++++++++++++++++++++++++++++++++++++' >> ${LOG_FILE}

unset _pack_var

local _script
for _script in ${LFS_PWD}/${PREFIX_LFS}/tools/${ID}_*/${ID}.[0-9][0-9]*.sh
do
	local _file=`basename "${_script}"`
	local _NAME=`echo ${_file} | cut -d_ -f2 | cut -d. -f1`

	local _log="${LOG_DIR}/${ID}/${_file}.log"
	if [[ -f ${_log} ]]; then
		rm -vf ${_log}
	fi
	local logpipe=`mktemp -u "${LOG_DIR}/${ID}/logpipe.XXXXXXXX"`
	mkfifo "${logpipe}"
	tee "${_log}" < "${logpipe}" &
	local teepid=${!}

	# Назначаем переменные пакета
	_pack_var=`pack_var "${BOOK}.${ID}.${_NAME}"`
	local ${_pack_var}
	local name="${_NAME}"

	while [ true ]
	do
		echo "${ID}    ${name}    ${_file}"
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

echo ${ERR_FLAG} > ${LOG_DIR}/${ID}/${ID}_flag
if [ ${ERR_FLAG} -eq 0 ]; then
	color-echo "OK: ${1}" ${GREEN}
else
	color-echo "ERROR: ${1}" ${RED} & return ${?}
fi

# clear
strip --strip-debug /tools/lib/* || true
strip --strip-unneeded /tools/{,s}bin/* || true
rm -rf /tools/{,share}/{info,man,doc}

color-echo "Создание файла: \"${ID}-files\"" ${GREEN}
find /tools/ | sed -e '1d' > ${LOG_DIR}/${ID}/${ID}-files

if [ "${ID}" != '05' ]; then
	color-echo 'Получаем переменную: "_raznost"' ${GREEN}
	local _files=`diff -n "${LOG_DIR}/05/05-files" "${LOG_DIR}/${ID}/${ID}-files" | grep '^/tools'`
else
	local _files=`cat ${LOG_DIR}/${ID}/${ID}-files`
fi

pushd ${LFS_OUT}
	color-echo "Создание архива: \"${archive}\"" ${GREEN}
	tar -cjf ${archive} ${_files}

	color-echo "Проверка архива: \"${archive}\"" ${CYAN}
	bzip2 -t ${archive}
popd

date >> ${LOG_FILE}
}

################################################################################
