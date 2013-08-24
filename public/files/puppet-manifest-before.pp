class {'phpsrc':
  phpver => '5.5.2',
  phpfiletest => '/usr/local/bin/php-cli',
  phpreinstall => true,
  phpopt_fpm => true,
  phpopt_fpm_user => 'www-data',
  phpopt_fpm_group => 'www-data',
  phpopt_enable_calendar => true,
  phpopt_with_curl => true,
  phpopt_enable_exif => true,
  phpopt_with_gd => true,
  phpopt_with_gettext => true,
  phpopt_with_mysql => true,
  phpopt_with_readline => true,
  phpopt_with_xmlrpc => true,
  phpopt_with_pear => true,
  phpopt_with_apx2 => true,
  phpopt_with_config_file_scan_dir => '/usr/local/php-5.5.2/etc/conf.d',
  phpopt_enable_inline_optimization => true,
  phpopt_disable_all => true,
  phpopt_enalbe_libxml => true,
  phpopt_enable_xml => true,
}
