#######################################
#local _name=$(echo ${LINUX_LFS} | cut -d\; -f2)
#local _version=$(echo ${LINUX_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

make mrproper || return ${?}
make headers_check || return ${?}
make INSTALL_HDR_PATH=/tools headers_install || return ${?}
#cp -rv dest/include/* /tools/include || return ${?}
popd

#######################################
