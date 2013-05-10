#######################################
#local _name=$(echo ${SED_LFS} | cut -d\; -f2)
#local _version=$(echo ${SED_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
