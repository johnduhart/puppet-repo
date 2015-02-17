class profile::engtools::teamcity {
	$engtools = hiera_hash('engtools')
	$teamcity = $engtools['teamcity']
	$dbhost = $teamcity['dbhost']
	$dbname = $teamcity['dbname']
	$datadir = '/mnt/atlassian-home/teamcity'

	postgresql::validate_db_connection { 'valid-teamcity-db':
		database_host     => $dbhost,
		database_username => $teamcity['dbuser'],
		database_password => $teamcity['dbpass'],
		database_name     => $dbname,
	} ->
	class { '::teamcity':
		installdir => '/opt/atlassian-install/teamcity',
		datadir => $datadir,
		dburl => "jdbc:postgresql://${dbhost}:5432/${dbname}",
		dbuser => $teamcity['dbuser'],
		dbpassword => $teamcity['dbpass'],
	}

	file { '/mnt/archive/teamcity':
		ensure => 'directory',
		owner => $::teamcity::user,
		group => $::teamcity::group,
	} ->
	file { "${datadir}/system/artifacts":
		ensure => 'link',
		target => '/mnt/archive/teamcity',
		owner => $::teamcity::user,
		group => $::teamcity::group,
		require => File["${datadir}/system"],
		before => Class['::teamcity::service'],
	}

	nginx::resource::upstream { 'teamcity':
		members => [ 'localhost:8111' ],
	} ->
	nginx::resource::map { 'connection_upgrade':
		string => '$http_upgrade',
		default => 'upgrade',
		mappings => {
			"''" => "''",
		}
	} ->
	nginx::resource::vhost { $teamcity['host']:
		listen_port          => '80',
		proxy                => 'http://teamcity',
		proxy_read_timeout   => '300',
		location_cfg_prepend => {
			'proxy_set_header X-Forwarded-For'    => '$proxy_add_x_forwarded_for',
			'proxy_set_header Host'               => '$host',
			'proxy_set_header Upgrade'            => '$http_upgrade',
			'proxy_set_header Connection'         => '$connection_upgrade',
			'proxy_redirect'                      => 'off',
		}
	}
}