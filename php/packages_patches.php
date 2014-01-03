#!/usr/bin/php

<?php

// name ; version ; home ; url ; md5

// Создаем DOM и загружаем страничку
$dom = new DOMDocument();
$dom->loadHTMLFile($argv[1]);

// Находим все теги DT
$dts = $dom->getElementsByTagName('dt');

// Находим все теги DD
$dds = $dom->getElementsByTagName('dd');

// Задаем массивы для чистки пробелов и переносов строк
$patterns = array ('/ /', '/\\n/');
$replace = array ('', '');

// Перебираем все теги DD
for ( $i = 0; $i < $dds->length; $i++ )
{
	// Создаем и сбрасываем переменные
	$name = '';
	$version = '';
	$site = '';
	$url = '';
	$md5 = '';

	// Выделяем тег DT для обработки
	$dt = $dts->item($i);

	$spans = $dt->getElementsByTagName('span');
	$span = $spans->item(0);
	$_name = explode( '(', preg_replace( $patterns, $replace, $span->nodeValue ) );
	$name = $_name[0];
	$_version = explode( ')', $_name[1] );
	$version = $_version[0];

	// Выделяем тег DD для обработки
	$dd = $dds->item($i);

	// Ишим дочерние теги P в теге DD
	$ps = $dd->getElementsByTagName('p');

	// Перебираем теги P
	for ( $n = 0; $n < $ps->length; $n++ )
	{
		// Выделяем тег P
		$p = $ps->item($n);

		// Разбиваем строку (значение тега P)
		$ap = explode( " ", preg_replace('/[\s]{2,}/', ' ', $p->nodeValue), 3 );

		// Ишим дочерние теги A в теге P
		$as = $p->getElementsByTagName('a');

		// Выделяем первый дочерний обьект тега A
		$var = $as->item(0);

		// Если тег A не найден, ишем тег CODE
		if ( empty($var) )
		{
			$codes = $p->getElementsByTagName('code');
			$var = $codes->item(0);
		}

		// Проверяем содержимое тега
		switch ( $ap[1] )
		{
			case 'Home': // Если это домашний url то уазываем значение переменной SITE
				$site = preg_replace( $patterns, $replace, $var->nodeValue );
				break;
			case 'Download:': // Если это url для загрузка архива уазываем значение переменной URL
				$url = preg_replace( $patterns, $replace, $var->nodeValue );

				// Находим полное имя архива
#				$urls = explode('/', $url);
#				$file = $urls[count($urls) - 1];

				// Отрезаем расширение архива и определяем точку разрыва имени пакета и версии
#				$_file = preg_replace( array ( '/.tar.gz/', '/.tar.bz2/', '/.tar.xz/' ), array ( '', '', '' ), $file );
#				$n_file = strcspn($_file,  '0123456789');

				// Указываем значение переменных NAME и VERSION
#				$name = ( substr( substr( $_file, 0, $n_file ), -1 ) == '-' ) ? substr( $_file, 0, $n_file -1 ) : substr( $_file, 0, $n_file );
#				$version = substr( $_file, $n_file );
				break;
			case 'MD5': // Если это md5-сумма то уазываем значение переменной MD5
				$md5 = preg_replace( $patterns, $replace, $var->nodeValue );
				break;
		}
	}
	// Выводим собранную информацию о пакете
	echo $name . ';' . $version . ';' . $site . ';' . $url . ';' . $md5 . "\n";
}
?>
