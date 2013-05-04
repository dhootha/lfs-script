#######################################
#local _name=$(echo ${OPENSSL_LFS} | cut -d\; -f2)
#local _version=$(echo ${OPENSSL_LFS} | cut -d\; -f3)
#local _url=$(echo ${OPENSSL_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

unset MAKEFLAGS

patch -Np1 -i ${LFS_SRC}/${name}-${version}-fix_manpages-1.patch || return 1
./config --prefix=/tools shared zlib-dynamic || return 1
make || return 1

make test || return 1
sed -i 's# libcrypto.a##;s# libssl.a##' Makefile || return 1

make MANDIR=/tools/share/man install || return 1

if [ ${J2_LFS_FLAG} -ne 0 ]; then
	export MAKEFLAGS="-j ${J2_LFS_FLAG}"
fi
popd

#######################################
