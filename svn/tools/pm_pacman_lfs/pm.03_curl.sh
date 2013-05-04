#######################################
#local _name=$(echo ${CURL_LFS} | cut -d\; -f2)
#local _version=$(echo ${CURL_LFS} | cut -d\; -f3)
#local _url=$(echo ${CURL_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

unset MAKEFLAGS

sed -i '/--static-libs)/{N;s#echo .*#echo #;}' curl-config.in || return ${?}
./configure --prefix=/tools --disable-static --without-libssh2 || return ${?}
#./configure --prefix=/tools --disable-static || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}

if [ ${J2_LFS_FLAG} -ne 0 ]; then
        export MAKEFLAGS="-j ${J2_LFS_FLAG}"
fi

popd

#######################################
