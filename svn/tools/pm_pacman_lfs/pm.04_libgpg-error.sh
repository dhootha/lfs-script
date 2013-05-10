#######################################
#local _name=$(echo ${LIBGPG_ERROR_LFS} | cut -d\; -f2)
#local _version=$(echo ${LIBGPG_ERROR_LFS} | cut -d\; -f3)
#local _url=$(echo ${LIBGPG_ERROR_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
