#######################################
#local _name=$(echo ${XZ_LFS} | cut -d\; -f2)
#local _version=$(echo ${XZ_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools             \
            --disable-makeinstall-chown \
            --without-systemdsystemunitdir || return ${?}
make || return ${?}
make install || return ${?}
popd

#######################################
