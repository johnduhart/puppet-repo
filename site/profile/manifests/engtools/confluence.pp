class profile::engtools::confluence {
	$engtools = hiera_hash('engtools')
	$confluence = $engtools['confluence']
	$dbhost = $confluence['dbhost']
	$dbname = $confluence['dbname']

	postgresql::validate_db_connection { 'valid-confluence-db':
		database_host     => $dbhost,
		database_username => $confluence['dbuser'],
		database_password => $confluence['dbpass'],
		database_name     => $dbname,
	} ->
	class { '::confluence':
		installdir => '/opt/atlassian-install/confluence',
		homedir => '/mnt/atlassian-home/confluence',
		javahome => '/usr/lib/jvm/java-8-oracle/',
		proxy => {
			scheme => 'http',
			proxyName => $confluence['host'],
			proxyPort => '80',
		}
	}

	nginx::resource::upstream { 'confluence':
		members => [ 'localhost:8090' ],
	} ->
	nginx::resource::vhost { $confluence['host']:
		listen_port          => '80',
		proxy                => 'http://confluence',
		proxy_read_timeout   => '300',
		location_cfg_prepend => {
			'proxy_set_header X-Forwarded-Host'   => '$host',
			'proxy_set_header X-Forwarded-Server' => '$host',
			'proxy_set_header X-Forwarded-For'    => '$proxy_add_x_forwarded_for',
			'proxy_set_header Host'               => '$host',
			'proxy_redirect'                      => 'off',
		}
	}
}