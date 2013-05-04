#######################################

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

mkdir -v ../${name}-build; cd ../${name}-build
../${PACK}/libstdc++-v3/configure   \
	--host=$LFS_TGT             \
	--prefix=/tools             \
	--disable-multilib          \
	--disable-shared            \
	--disable-nls               \
	--disable-libstdcxx-threads \
	--disable-libstdcxx-pch     \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/${version} || return 1
make || return 1
make install || return 1

popd

#######################################
