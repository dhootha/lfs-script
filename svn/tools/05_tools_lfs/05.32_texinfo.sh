#######################################
#local _name=$(echo ${TAR_LFS} | cut -d\; -f2)
#local _version=$(echo ${TAR_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/${name}-${version}-test-1.patch || return ${?}

./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
