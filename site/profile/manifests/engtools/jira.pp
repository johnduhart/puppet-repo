class profile::engtools::jira {
	$engtools = hiera_hash('engtools')
	$jira = $engtools['jira']

	class { '::jira':
		installdir => '/opt/atlassian-install/jira',
		homedir => '/mnt/atlassian-home/jira',
		dbname => $jira['dbname'],
		dbserver => $jira['dbhost'],
		dbuser => $jira['dbuser'],
		dbpassword => $jira['dbpass'],
		javahome => '/usr/lib/jvm/java-8-oracle/',
		proxy => {
			scheme => 'http',
			proxyName => $jira['host'],
			proxyPort => '80',
		}
	}

	class { '::jira::facts': }

	nginx::resource::upstream { 'jira':
		members => [ 'localhost:8080' ],
	} ->
	nginx::resource::vhost { $jira['host']:
		listen_port          => '80',
		proxy                => 'http://jira',
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