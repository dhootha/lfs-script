#!/bin/bash
#######################################
# config
# Version: test

local PREFIX_LFS='svn'
local LFS='/mnt/lfs'
local LFS_SRC="${LFS_PWD}/${PREFIX_LFS}/sources"
local LFS_OUT="${LFS_PWD}/output"
local LFS_PKG="${LFS_OUT}/pkg"
local LFS_LOG="${LFS_OUT}/log"
local LFS_PHP="${LFS_PWD}/php"
local BUILD_DIR="${LFS_PWD}/build"

local PACKAGE_MANAGER='pacman'

local PACKAGE_GROUPS=('base' 'base-devel')
local PACKAGE_FORCE=('base-core' 'glibc' 'binutils' 'gcc' 'shadow' 'coreutils' 'bash' 'perl' 'bash-completion')

local HOSTNAME='inet'
local ns1_IP='8.8.4.4'
local ns2_IP='8.8.8.8'
local PATH_CHROOT='/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin'

# flags
local LFS_FLAG='lfs'
local CHROOT_FLAG=${CHROOT_FLAG:-0}
local J2_LFS_FLAG="$(( `grep -c '^processor' /proc/cpuinfo` + 1 ))"
local PACKAGE_MANAGER_FLAG=${PACKAGE_MANAGER_FLAG:-1}
local MOUNT_LFS_FLAG=${MOUNT_LFS_FLAG:-0}
local PACKAGES_PATCHES_LFS_FLAG=${PACKAGES_PATCHES_LFS_FLAG:-0}
local PACKAGES_LFS_FLAG=${PACKAGES_LFS_FLAG:-0}
local TOOLS_LFS_FLAG=${TOOLS_LFS_FLAG:-0}		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local SYSTEM_LFS_FLAG=${SYSTEM_LFS_FLAG:-0}		# 0 = 00; 1 = -1; 2 = 10; 3 = 11.
local BLFS_FLAG=${BLFS_FLAG:-0}
local ERR_FLAG=${ERR_FLAG:-0}

#######################################
