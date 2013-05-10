#######################################
#local _name=$(echo ${XZ_LFS} | cut -d\; -f2)
#local _version=$(echo ${XZ_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
