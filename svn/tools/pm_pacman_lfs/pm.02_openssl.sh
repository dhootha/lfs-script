#######################################
#local _name=$(echo ${OPENSSL_LFS} | cut -d\; -f2)
#local _version=$(echo ${OPENSSL_LFS} | cut -d\; -f3)
#local _url=$(echo ${OPENSSL_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

unset MAKEFLAGS

patch -Np1 -i ${LFS_SRC}/${name}-${version}-fix_parallel_build-1.patch || return ${?}
patch -Np1 -i ${LFS_SRC}/${name}-${version}-fix_pod_syntax-1.patch || return ${?}
./config --prefix=/tools shared zlib-dynamic || return ${?}
make || return ${?}

make test || return ${?}
sed -i 's# libcrypto.a##;s# libssl.a##' Makefile || return ${?}

make MANDIR=/tools/share/man MANSUFFIX=ssl install || return ${?}

if [ ${J2_LFS_FLAG} -ne 0 ]; then
	export MAKEFLAGS="-j ${J2_LFS_FLAG}"
fi
popd

#######################################
