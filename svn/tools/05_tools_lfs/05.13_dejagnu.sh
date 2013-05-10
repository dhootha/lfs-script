#######################################
#local _name=$(echo ${DEJAGNU_LFS} | cut -d\; -f2)
#local _version=$(echo ${DEJAGNU_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools || return ${?}
make install || return ${?}
make check || return ${?}
popd

#######################################
