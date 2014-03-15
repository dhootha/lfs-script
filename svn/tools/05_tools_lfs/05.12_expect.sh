#######################################
#local _name=$(echo ${EXPECT_LFS} | cut -d\; -f2)
#local _version=$(echo ${EXPECT_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include || return ${?}
make || return ${?}
make test || return ${?}
make SCRIPTS="" install || return ${?}
popd

#######################################
