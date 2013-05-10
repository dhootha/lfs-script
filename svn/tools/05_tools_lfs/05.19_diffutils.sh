#######################################
#local _name=$(echo ${DIFFUTILS_LFS} | cut -d\; -f2)
#local _version=$(echo ${DIFFUTILS_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

sed -i -e '/gets is a/d' lib/stdio.in.h
./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
