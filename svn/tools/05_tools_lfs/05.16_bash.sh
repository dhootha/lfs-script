#######################################

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/${name}-${version}-fixes-12.patch || return 1
./configure --prefix=/tools --without-bash-malloc || return 1
make || return 1
make tests || return 1
make install || return 1
ln -vs bash /tools/bin/sh
popd

#######################################
