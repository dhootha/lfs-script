<?php
$arr = array (

# notlfs pm
'archlinux-keyring' => array (
		'status' => '1',
		'notlfs' => 'pm',
		'version' => '20131027',
		'md5' => 'cad222524edafc82f739d8b0f3059287',
		'url' => 'https://projects.archlinux.org/archlinux-keyring.git/snapshot/archlinux-keyring-_version.tar.gz'
	),

'pacman' => array (
		'status' => '1',
		'notlfs' => 'pm',
		'version' => '4.1.2',
		'md5' => '063c8b0ff6bdf903dc235445525627cd',
		'url' => 'ftp://ftp.archlinux.org/other/pacman/pacman-_version.tar.gz',

		'depends_lfs' => 'blfs.12.libarchive>=3.1.2:blfs.17.curl>=7.19.4:blfs.04.gpgme:notlfs.pm.archlinux-keyring',
		'depends_notlfs' => 'blfs.12.libarchive>=3.1.2:blfs.17.curl>=7.19.4:blfs.04.gpgme:notlfs.pm.archlinux-keyring'
	),

);
?>
