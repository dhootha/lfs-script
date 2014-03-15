#######################################

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

if [ ! -r /usr/include/rpc/types.h ]; then
  su -c 'mkdir -p /usr/include/rpc' || return ${?}
  su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc' || return ${?}
fi

mkdir -v ../${name}-build; cd ../${name}-build

../${PACK}/configure                               \
	--prefix=/tools                            \
	--host=$LFS_TGT                            \
	--build=$(../${PACK}/scripts/config.guess) \
	--disable-profile                          \
	--enable-kernel=2.6.32                     \
	--with-headers=/tools/include              \
	libc_cv_forced_unwind=yes                  \
	libc_cv_ctors_header=yes                   \
	libc_cv_c_cleanup=yes || return ${?}
make || return ${?}
make install || return ${?}

echo 'Test compiling C' >> ${_log}
echo 'main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools' | tee -a ${_log}
rm -v dummy.c a.out

popd

#######################################
