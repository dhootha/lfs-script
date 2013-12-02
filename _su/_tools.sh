#!/bin/bash
################################################################################
# Функция "_tools_lfs"
# Version: 0.1

_tools_lfs ()
{
local LFS_FLAG='_tools-lfs'

cd ${LFS_PWD}
for _functions in ${LFS_PWD}/_functions/*.sh
do
	. ${_functions}
done

# Перехватываем ошибки.
local restoretrap

set -eE

restoretrap=`trap -p ERR`
trap '_ERROR' ERR
eval $restoretrap

# Удаляем запуск скрипта.
sed -e "/\/_su\/_tools.sh/d" \
    -e '/^exit/d' \
    -i ~/.bashrc

# Назначение переменных (массивов) хроняших информацию о пакетах.
array_packages

# Каталог для хронения лог-файлов tools
LOG_DIR="${LFS_LOG}/tools"
install -d ${LOG_DIR}

scripts_tools 'pm.Pacman' '05.Constructing Cross-Compile Tools'

set +Ee
}

_tools_lfs

################################################################################
