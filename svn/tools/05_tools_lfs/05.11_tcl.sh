#######################################
#local _name=$(echo ${TCL_LFS} | cut -d\; -f2)
#local _version=$(echo ${TCL_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
#unarch "${name}${version}" || return 1
unarch || return 1
local version=$(echo ${version} | cut -d- -f1)
local PACK="${name}${version}"
cd ./${PACK}/unix

sed -i s/500/5000/ ../unix/generic/regc_nfa.c
./configure --prefix=/tools || return 1
make || return 1
TZ=UTC make test || return 1
make install || return 1
chmod -v u+w /tools/lib/libtcl8.6.so || return 1
make install-private-headers || return 1
ln -sv tclsh8.6 /tools/bin/tclsh
popd

#######################################
