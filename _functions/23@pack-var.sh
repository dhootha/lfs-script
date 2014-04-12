#!/bin/bash
################################################################################
# Функция "pack-var"
# Version: 0.1

pack_var ()
{
local php_conf_dir="${LFS_PWD}/${PREFIX_LFS}/packages.conf.php"

${LFS_PWD}/_functions/php/pack_var.php ${php_conf_dir} ${1}
}

################################################################################
