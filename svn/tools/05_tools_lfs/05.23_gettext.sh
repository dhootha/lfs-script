#######################################
#local _name=$(echo ${GETTEXT_LFS} | cut -d\; -f2)
#local _version=$(echo ${GETTEXT_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

sed -i -e '/gets is a/d' gettext-*/*/stdio.in.h
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared || return ${?}
make -C gnulib-lib || return ${?}
make -C src msgfmt || return ${?}
make -C src msgmerge
make -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
popd

#######################################
