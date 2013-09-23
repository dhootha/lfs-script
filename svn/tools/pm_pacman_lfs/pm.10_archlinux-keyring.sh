#######################################
#local _name=$(echo ${PACMAN_LFS} | cut -d\; -f2)
#local _version=$(echo ${PACMAN_LFS} | cut -d\; -f3)
#local _url=$(echo ${PACMAN_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

make PREFIX=/tools install || return ${?}
popd

#######################################
