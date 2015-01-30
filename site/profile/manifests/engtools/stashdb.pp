class profile::engtools::stashdb {
	$engtools = hiera_hash('engtools')
	$stash = $engtools['stash']
	
	postgresql::server::db { $stash['dbname']:
		user       => $stash['dbuser'],
		password   => postgresql_password($stash['dbuser'], $stash['dbpass']),
		tablespace => 'toolsts',
	}
}