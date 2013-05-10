#######################################

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/${name}-${version}-fixes-12.patch || return ${?}
./configure --prefix=/tools --without-bash-malloc || return ${?}
make || return ${?}
make tests || return ${?}
make install || return ${?}
ln -vs bash /tools/bin/sh
popd

#######################################
