#######################################

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

#patch -Np1 -i ${LFS_SRC}/${name}-${version}-build_fix-1.patch || return 1

sed -i -e 's/@colophon/@@colophon/' \
       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo || return 1

mkdir -v ../${name}-build; cd ../${name}-build
CC=$LFS_TGT-gcc                    \
AR=$LFS_TGT-ar                     \
RANLIB=$LFS_TGT-ranlib             \
../${PACK}/configure               \
	--prefix=/tools            \
	--disable-nls              \
	--with-lib-path=/tools/lib \
	--with-sysroot || return 1
make || return 1
make install || return 1
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

echo 'Test compiling C' >> ${_log}
echo 'main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools' | tee -a ${_log}
rm -v dummy.c a.out

popd

#######################################
