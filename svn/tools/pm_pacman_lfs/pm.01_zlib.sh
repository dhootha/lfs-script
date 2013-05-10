#######################################
#local _name=$(echo ${ZLIB_LFS} | cut -d\; -f2)
#local _version=$(echo ${ZLIB_LFS} | cut -d\; -f3)
#local _url=$(echo ${ZLIB_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

unset MAKEFLAGS
sed -i 's/ifdef _LARGEFILE64_SOURCE/ifndef _LARGEFILE64_SOURCE/' zlib.h || return ${?}
CFLAGS='-mstackrealign -fPIC -O3' ./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
if [ ${J2_LFS_FLAG} -ne 0 ]; then
	export MAKEFLAGS="-j ${J2_LFS_FLAG}"
fi
popd

#######################################
