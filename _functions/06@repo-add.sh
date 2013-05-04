#!/bin/bash
################################################################################
# Функция "repo-add"
# Version: 0.1

repo-add_lfs ()
{
pushd ${LFS_PKG}
	rm -f ./core.* || return ${?}
	repo-add -s ./core.db.tar.xz *.pkg.tar.xz | tee ${LFS_LOG}/repo-add.log
	[ "${?}" -ne 0 ] && return ${?}
popd
}

################################################################################
