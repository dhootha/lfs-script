<?php
$arr = array (

# blfs 17
'curl' => array (
		'status' => '1',
		'notlfs' => 'pm',
		'blfs' => '17',
		'version' => '7.33.0',
		'md5' => '57409d6bf0bd97053b8378dbe0cadcef',
		'url' => 'http://curl.haxx.se/download/curl-_version.tar.bz2',

		'depends_notlfs' => 'blfs.04.ca-certificates:blfs.04.openssl',
		'depends_blfs' => 'blfs.04.ca-certificates:blfs.04.openssl',

		'makedepends_notlfs' => 'blfs.13.python2',
		'makedepends_blfs' => 'blfs.13.python2'
	),

		//'md5patch1' => '',
		//'urlpatch1' => 'http://www.linuxfromscratch.org/patches/blfs/svn/curl-_version-upstream_fixes-1.patch',

'libtirpc' => array (
		'status' => '1',
		'blfs' => '17',
		'version' => '0.2.3',
		'md5' => 'b70e6c12a369a91e69fcc3b9feb23d61',
		'url' => 'http://downloads.sourceforge.net/project/libtirpc/libtirpc/_version/libtirpc-_version.tar.bz2',

		'md5patch1' => 'f49ce11a45d63219e01e9ababcb572c2',
		'urlpatch1' => 'http://www.linuxfromscratch.org/patches/blfs/svn/libtirpc-_version-remove_nis-1.patch'
	),

);
?>
