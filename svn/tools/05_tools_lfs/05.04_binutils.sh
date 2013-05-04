#######################################

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

#patch -Np1 -i ${LFS_SRC}/${name}-${version}-build_fix-1.patch || return 1

sed -i -e 's/@colophon/@@colophon/' \
       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo || return 1

mkdir -v ../${name}-build; cd ../${name}-build
../${PACK}/configure               \
	--prefix=/tools            \
	--with-sysroot=$LFS        \
	--with-lib-path=/tools/lib \
	--target=$LFS_TGT          \
	--disable-nls              \
	--disable-werror || return 1
make || return 1
case $(uname -m) in
	x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install || return 1
popd

#######################################
