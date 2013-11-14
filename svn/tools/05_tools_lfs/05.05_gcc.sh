#######################################

pushd ${BUILD_DIR}
unarch 'mpfr' 'gmp' 'mpc' || return ${?}
cd ./${PACK}

mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc

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

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

mkdir -v ../${name}-build; cd ../${name}-build
../${PACK}/configure               \
	--target=$LFS_TGT          \
	--prefix=/tools            \
	--with-sysroot=$LFS        \
	--with-newlib              \
	--without-headers          \
	--with-local-prefix=/tools \
	--with-native-system-header-dir=/tools/include \
	--disable-nls              \
	--disable-shared           \
	--disable-multilib         \
	--disable-decimal-float    \
	--disable-threads          \
	--disable-libatomic        \
	--disable-libgomp          \
	--disable-libitm           \
	--disable-libmudflap       \
	--disable-libquadmath      \
	--disable-libsanitizer     \
	--disable-libssp           \
	--disable-libstdc++-v3     \
	--enable-languages=c,c++   \
	--with-mpfr-include=$(pwd)/../${PACK}/mpfr/src \
	--with-mpfr-lib=$(pwd)/mpfr/src/.libs || return ${?}
make || return ${?}
make install || return ${?}
ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`
popd

#######################################
