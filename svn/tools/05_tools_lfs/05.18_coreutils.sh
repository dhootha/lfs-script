#######################################
#local _name=$(echo ${COREUTILS_LFS} | cut -d\; -f2)
#local _version=$(echo ${COREUTILS_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

#patch -Np1 -i ${LFS_SRC}/${name}-${version}-test_fixes-1.patch || return 1

FORCE_UNSAFE_CONFIGURE=1 ./configure    \
	--prefix=/tools			\
	--enable-install-program=hostname || return 1
make || return 1
make RUN_EXPENSIVE_TESTS=yes check || return 1
make install || return 1
cp -v src/su /tools/bin/

# чтобы не сбивалось время в логе
export TZ=/etc/localtime
popd

#######################################
