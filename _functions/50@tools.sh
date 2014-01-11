#!/bin/bash
################################################################################
# Функция "tools_lfs"
# Version: 0.1

tools_lfs ()
{
local LFS_FLAG='tools-lfs'

[ "${ERR_FLAG}" -gt 0 ] && return ${ERR_FLAG}

case ${TOOLS_LFS_FLAG} in
	3) rm -fv ${LFS_OUT}/??_$(uname -m)_lfs.tar.bz2 ;;
	2) rm -fv ${LFS_OUT}/pm_$(uname -m)_lfs.tar.bz2 ;;
	1) rm -fv ${LFS_OUT}/05_$(uname -m)_lfs.tar.bz2 ;;
	0)
		if [ "${CHROOT_FLAG}" -eq 0 ] && \
		   [ "${SYSTEM_LFS_FLAG}" -eq 0 ] && \
		   [ "${BLFS_FLAG}" -eq 0 ]; then
			return 0
		fi
	;;
	*) echo 'Не верный параметер константы "TOOLS_LFS_FLAG"' ;;
esac

color-echo "tools_lfs" ${YELLOW}

date > "${LFS_LOG}/tools_lfs.log"

# Основные каталоги и ссылки
install -dv "${LFS}/tools" ${LFS_SRC}
ln -sv "${LFS}/tools" /

# Очистка сборочной папки
rm -Rf ${BUILD_DIR}
install -dv ${BUILD_DIR}
#install -dv ${LFS}${BUILD_DIR}
#mount --bind ${LFS}${BUILD_DIR} ${BUILD_DIR}

if [ -z "$(fgrep lfs /etc/group)" ]; then
	groupadd lfs
fi

if [ -z "$(fgrep lfs /etc/passwd)" ]; then
	useradd -s /bin/bash -g lfs -m -k /dev/null lfs
else
	usermod -s /bin/bash -g lfs -m -d /home/lfs lfs
fi

yes lfs | passwd lfs

chown -v lfs "${LFS}/tools" "${LFS_SRC}" "${LFS_LOG}"
chmod -R a+wt "${LFS_SRC}"

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << EOF
set +h
umask 022
LFS=${LFS}
LC_ALL=POSIX
LFS_TGT=\$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

if [ ${J2_LFS_FLAG} -gt 0 ]; then
	echo "export MAKEFLAGS=\"-j ${J2_LFS_FLAG}\"" >> /home/lfs/.bashrc
fi

# ---------------------------------
cat >> /home/lfs/.bashrc << EOF
LFS_PWD="${LFS_PWD}"
export LFS_PWD

${LFS_PWD}/_su/_tools.sh
exit \${?}
EOF

# Каталог для хронения лог-файлов tools
#_LOG="${LFS_LOG}/tools"
#install -d ${_LOG}

# ---------------------------------
chown -Rv lfs /home/lfs ${LFS_OUT} ${BUILD_DIR}

su - lfs

if [ -n "$(mount | grep ${BUILD_DIR})" ]; then
	umount -v ${BUILD_DIR}
	rm -Rf ${LFS}${BUILD_DIR} ${BUILD_DIR}
fi

date >> "${LFS_LOG}/tools_lfs.log"
}

################################################################################
