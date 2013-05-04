#######################################
#local _name=$(echo ${BZIP2_LFS} | cut -d\; -f2)
#local _version=$(echo ${BZIP2_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

make -f Makefile-libbz2_so || return 1
make || return 1
make PREFIX=/tools install || return 1
popd

#######################################
