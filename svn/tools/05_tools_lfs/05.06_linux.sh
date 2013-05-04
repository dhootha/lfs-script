#######################################
#local _name=$(echo ${LINUX_LFS} | cut -d\; -f2)
#local _version=$(echo ${LINUX_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

make mrproper || return 1
make headers_check || return 1
make INSTALL_HDR_PATH=dest headers_install || return 1
cp -rv dest/include/* /tools/include || return 1
popd

#######################################
