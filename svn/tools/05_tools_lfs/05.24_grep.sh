#######################################
#local _name=$(echo ${GREP_LFS} | cut -d\; -f2)
#local _version=$(echo ${GREP_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

./configure --prefix=/tools \
	--disable-perl-regexp || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
