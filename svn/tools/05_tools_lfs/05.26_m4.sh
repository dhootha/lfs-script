#######################################
#local _name=$(echo ${M4_LFS} | cut -d\; -f2)
#local _version=$(echo ${M4_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

sed -i -e '/gets is a/d' lib/stdio.in.h
./configure --prefix=/tools || return 1
make || return 1
# Взято с главы 6 для устранения ошибки test-readlink
#sed -i -e '41s/ENOENT/& || errno == EINVAL/' tests/test-readlink.h
make check || return 1
make install || return 1
popd

#######################################
