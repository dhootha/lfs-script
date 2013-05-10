#######################################
#local _name=$(echo ${TCL_LFS} | cut -d\; -f2)
#local _version=$(echo ${TCL_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
#unarch "${name}${version}" || return ${?}
unarch || return ${?}
local version=$(echo ${version} | cut -d- -f1)
local PACK="${name}${version}"
cd ./${PACK}/unix

sed -i s/500/5000/ ../unix/generic/regc_nfa.c
./configure --prefix=/tools || return ${?}
make || return ${?}
TZ=UTC make test || return ${?}
make install || return ${?}
chmod -v u+w /tools/lib/libtcl8.6.so || return ${?}
make install-private-headers || return ${?}
ln -sv tclsh8.6 /tools/bin/tclsh
popd

#######################################
