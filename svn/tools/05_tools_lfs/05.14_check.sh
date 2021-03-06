#######################################
#local _name=$(echo ${CHECK_LFS} | cut -d\; -f2)
#local _version=$(echo ${CHECK_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

PKG_CONFIG= ./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
