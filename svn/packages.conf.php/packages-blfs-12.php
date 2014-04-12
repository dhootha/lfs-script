<?php
$arr = array (

# blfs 12
'libarchive' => array (
		'status' => '1',
		'notlfs' => 'pm',
		'blfs' => '12',
		'version' => '3.1.2',
		'md5' => 'efad5a503f66329bb9d2f4308b5de98a',
		'url' => 'http://www.libarchive.org/downloads/libarchive-_version.tar.gz',

		'md5patch1' => '9727baf88b928417d5d1269891b1209a',
		'urlpatch1' => 'https://github.com/josephgbr/pkgbuilds/raw/master/lib32-libarchive/0001-mtree-fix-line-filename-length-calculation.patch'
	),

'mc' => array (
		'status' => '1',
		'blfs' => '12',
		'version' => '4.8.7',
		'md5' => '3e825e767f85a57af210919f9f6c90b2',
		'url' => 'http://www.midnight-commander.org/downloads/mc-_version.tar.xz',

		'depends_blfs' => 'blfs.09.glib2:blfs.09.pcre'
	),

);
?>
