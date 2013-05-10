#######################################
#local _name=$(echo ${BZIP2_LFS} | cut -d\; -f2)
#local _version=$(echo ${BZIP2_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

make -f Makefile-libbz2_so || return ${?}
make || return ${?}
make PREFIX=/tools install || return ${?}
popd

#######################################
