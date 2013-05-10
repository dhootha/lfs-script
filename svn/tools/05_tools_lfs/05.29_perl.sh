#######################################

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/${PACK}-libc-1.patch || return ${?}

sh Configure -des -Dprefix=/tools || return ${?}
make || return ${?}
cp -v perl cpan/podlators/pod2man /tools/bin || return ${?}
mkdir -pv /tools/lib/perl5/${version} || return ${?}
cp -Rv lib/* /tools/lib/perl5/${version} || return ${?}
popd

#######################################
