#######################################
#local _name=$(echo ${NCURSES_LFS} | cut -d\; -f2)
#local _version=$(echo ${NCURSES_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

./configure --prefix=/tools	\
            --with-shared	\
            --without-debug	\
            --without-ada	\
            --enable-overwrite || return ${?}
#            --without-gpm || return 1 # Otkluchaem packet GPM
make || return ${?}
make install || return ${?}
popd

#######################################
