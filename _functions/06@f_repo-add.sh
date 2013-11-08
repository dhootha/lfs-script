#!/bin/bash
################################################################################
# Функция "f_repo-add"
# Version: 0.1

f_repo-add ()
{
pushd ${LFS_PKG}
	rm -f ./core.*
	repo-add -s ./core.db.tar.xz *.pkg.tar.xz | tee ${LFS_LOG}/repo-add.log
#	[ "${?}" -ne 0 ] && return ${?}
popd
}

################################################################################
