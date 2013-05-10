#######################################
#local _name=$(echo ${PACMAN_LFS} | cut -d\; -f2)
#local _version=$(echo ${PACMAN_LFS} | cut -d\; -f3)
#local _url=$(echo ${PACMAN_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

LIBARCHIVE_LIBS='-L/tools/lib -larchive' \
LIBARCHIVE_CFLAGS='-I/tools/include'     \
./configure --prefix=/tools              \
            --with-libcurl=/tools        \
            --with-pkg-ext='.pkg.tar.xz' \
            --with-src-ext='.src.tar.xz' || return ${?}
make || return ${?}
#make -C "${BUILD_DIR}/${PACK}" check || return ${?}
make install || return ${?}
# Настройка makepkg.conf
sed -e "s/\/usr\/bin\/curl/\/tools\/bin\/curl/g" -i /tools/etc/makepkg.conf
sed -e 's/{man,info}/man/g' -i /tools/etc/makepkg.conf
sed -e 's/{doc,gtk-doc}/{doc,gtk-doc,info}/g' -i /tools/etc/makepkg.conf
sed -e 's/OPTIONS=(strip docs libtool emptydirs zipman purge !upx)/OPTIONS=(strip !docs libtool emptydirs zipman purge !upx)/g' \
    -i /tools/etc/makepkg.conf
#sed -e 's@/bin/du@/du@g' \
#    -i /tools/bin/makepkg
popd

#######################################
