#######################################
#local _name=$(echo ${TAR_LFS} | cut -d\; -f2)
#local _version=$(echo ${TAR_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

./configure --prefix=/tools || return 1
make || return 1
make check || return 1
make install || return 1
popd

#######################################
