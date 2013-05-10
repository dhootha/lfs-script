#######################################

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}
name=`echo ${PACK} | cut -d- -f1`

mkdir -v ../${name}-build; cd ../${name}-build
../${PACK}/libstdc++-v3/configure   \
	--host=$LFS_TGT             \
	--prefix=/tools             \
	--disable-multilib          \
	--disable-shared            \
	--disable-nls               \
	--disable-libstdcxx-threads \
	--disable-libstdcxx-pch     \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/${version} || return ${?}
make || return ${?}
make install || return ${?}

popd

#######################################
