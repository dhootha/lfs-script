#######################################
#local _name=$(echo ${GETTEXT_LFS} | cut -d\; -f2)
#local _version=$(echo ${GETTEXT_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

sed -i -e '/gets is a/d' gettext-*/*/stdio.in.h
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared || return 1
make -C gnulib-lib || return 1
make -C src msgfmt || return 1
cp -v src/msgfmt /tools/bin
popd

#######################################
