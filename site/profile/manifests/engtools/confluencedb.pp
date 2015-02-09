class profile::engtools::confluencedb {
	$engtools = hiera_hash('engtools')
	$confluence = $engtools['confluence']
	
	postgresql::server::db { $confluence['dbname']:
		user       => $confluence['dbuser'],
		password   => postgresql_password($confluence['dbuser'], $confluence['dbpass']),
		tablespace => 'toolsts',
	}
}