class profile::engtools::jiradb {
	$engtools = hiera_hash('engtools')
	$jira = $engtools['jira']
	
	postgresql::server::db { $jira['dbname']:
		user     => $jira['dbuser'],
		password => postgresql_password($jira['dbuser'], $jira['dbpass']),
	}
}