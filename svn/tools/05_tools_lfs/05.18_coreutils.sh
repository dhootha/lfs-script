#######################################
#local _name=$(echo ${COREUTILS_LFS} | cut -d\; -f2)
#local _version=$(echo ${COREUTILS_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

#patch -Np1 -i ${LFS_SRC}/${name}-${version}-test_fixes-1.patch || return ${?}

./configure --prefix=/tools --enable-install-program=hostname || return ${?}
make || return ${?}
make RUN_EXPENSIVE_TESTS=yes check || return ${?}
make install || return ${?}
#cp -v src/su /tools/bin/

# чтобы не сбивалось время в логе
export TZ=/etc/localtime
popd

#######################################
