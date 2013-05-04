#######################################
#local _name=$(echo ${DEJAGNU_LFS} | cut -d\; -f2)
#local _version=$(echo ${DEJAGNU_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

./configure --prefix=/tools || return 1
make install || return 1
make check || return 1
popd

#######################################
