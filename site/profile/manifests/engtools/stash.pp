class profile::engtools::stash {
	$engtools = hiera_hash('engtools')
	$stash = $engtools['stash']
	$dbhost = $stash['dbhost']
	$dbname = $stash['dbname']

	apt::ppa { 'ppa:git-core/ppa': } ->
	package { 'git':
		ensure      => installed,
		provider    => apt,
	} ->
	postgresql::validate_db_connection { 'valid-stash-db':
		database_host     => $dbhost,
		database_username => $stash['dbuser'],
		database_password => $stash['dbpass'],
		database_name     => $dbname,
	} ->
	class { '::stash':
		installdir => '/opt/atlassian-install/stash',
		homedir => '/mnt/atlassian-home/stash',
		dburl => "jdbc:postgresql://${dbhost}:5432/${dbname}",
		dbuser => $stash['dbuser'],
		dbpassword => $stash['dbpass'],
		javahome => '/usr/lib/jvm/java-8-oracle/',
		proxy => {
			scheme => 'http',
			proxyName => $stash['host'],
			proxyPort => '80',
		}
	}

	class { '::stash::gc': }
	class { '::stash::facts': }

	nginx::resource::upstream { 'stash':
		members => [ 'localhost:7990' ],
	} ->
	nginx::resource::vhost { $stash['host']:
		listen_port          => '80',
		proxy                => 'http://stash',
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