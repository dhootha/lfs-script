#!/bin/bash
################################################################################
# Функция "f_repo-add"
# Version: 0.1

f_repo-add ()
{
local repo_dir
for repo_dir in ${LFS_PKG}/*
do
	local repo_name=`basename ${repo_dir}`
	pushd ${repo_dir}
		rm -f ./${repo_name}.*
		repo-add -s ./${repo_name}.db.tar.xz *.pkg.tar.xz | tee ${LFS_LOG}/repo-add_${repo_name}.log
	popd
done
}

################################################################################
