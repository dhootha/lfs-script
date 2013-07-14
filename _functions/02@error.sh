#!/bin/bash
################################################################################
# Функция "_ERROR"
# Version: 0.1

_ERROR ()
{
local _ERR=${?}

color-echo "Ошибка № ${_ERR} в ${LFS_FLAG} !!!" ${RED}

read

case "${LFS_FLAG}" in
	lfs | tools-lfs) umount_lfs ;;
esac

exit ${_ERR}
}

################################################################################
