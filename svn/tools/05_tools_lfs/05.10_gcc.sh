#######################################

pushd ${BUILD_DIR}
unarch 'mpfr' 'gmp' 'mpc' || return 1
cd ./${PACK}

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

cp -v gcc/Makefile.in{,.tmp}
sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
  > gcc/Makefile.in

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc

mkdir -v ../${name}-build; cd ../${name}-build
CC=$LFS_TGT-gcc                 \
CXX=$LFS_TGT-g++                \
AR=$LFS_TGT-ar                  \
RANLIB=$LFS_TGT-ranlib          \
../${PACK}/configure            \
    --prefix=/tools             \
    --with-local-prefix=/tools  \
    --with-native-system-header-dir=/tools/include \
    --enable-clocale=gnu        \
    --enable-shared             \
    --enable-threads=posix      \
    --enable-__cxa_atexit       \
    --enable-languages=c,c++    \
    --disable-libstdcxx-pch     \
    --disable-multilib          \
    --disable-bootstrap         \
    --disable-libgomp           \
    --with-mpfr-include=$(pwd)/../${PACK}/mpfr/src \
    --with-mpfr-lib=$(pwd)/mpfr/src/.libs || return 1
make || return 1
make install || return 1
ln -vs gcc /tools/bin/cc

echo 'Test compiling C' >> ${_log}
echo 'main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools' | tee -a ${_log}
rm -v dummy.c a.out

popd

#######################################
