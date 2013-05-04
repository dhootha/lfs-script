#######################################
#local _name=$(echo ${GAWK_LFS} | cut -d\; -f2)
#local _version=$(echo ${GAWK_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

#unset MAKEFLAGS
./configure --prefix=/tools || return 1
make || return 1
make check || return 1
make install || return 1
#if [ ${J2_LFS_FLAG} -ne 0 ]; then
#	export MAKEFLAGS='-j 2'
#fi
popd

#######################################
