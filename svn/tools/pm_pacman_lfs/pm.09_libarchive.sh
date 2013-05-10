#######################################
#local _name=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f2)
#local _version=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f3)
#local _url=$(echo ${LIBARCHIVE_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

patch -Np1 -i ${LFS_SRC}/0001-mtree-fix-line-filename-length-calculation.patch

./configure --prefix=/tools \
	    --without-xml2  || return ${?}
#	    --without-expat || return ${?}

# Внесены изменения в пакет bzip2
make || return ${?}
make check || return ${?}
make install || return ${?}
popd

#######################################
