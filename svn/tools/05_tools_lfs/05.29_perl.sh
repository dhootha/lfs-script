#######################################

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/${PACK}-libc-1.patch || return 1

sh Configure -des -Dprefix=/tools || return 1
make || return 1
cp -v perl cpan/podlators/pod2man /tools/bin || return 1
mkdir -pv /tools/lib/perl5/${version} || return 1
cp -Rv lib/* /tools/lib/perl5/${version} || return 1
popd

#######################################
