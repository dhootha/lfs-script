#######################################
#local _name=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f2)
#local _version=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f3)
#local _url=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

./configure --prefix=/tools \
	    --without-xml2  || return 1
#	    --without-expat || return 1

# Внесены изменения в пакет bzip2
make || return 1
#make check || return 1
make install || return 1
popd

#######################################
