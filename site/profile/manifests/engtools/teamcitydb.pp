class profile::engtools::teamcitydb {
	$engtools = hiera_hash('engtools')
	$teamcity = $engtools['teamcity']
	
	postgresql::server::db { $teamcity['dbname']:
		user     => $teamcity['dbuser'],
		password => postgresql_password($teamcity['dbuser'], $teamcity['dbpass']),
	}
}