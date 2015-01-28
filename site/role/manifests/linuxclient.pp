class role::linuxclient {
	include profile::base
	include java::oracle_1_8_0


	file { 'atlassian-install':
		ensure => 'directory',
		path => '/opt/atlassian-install',
	} ->
	file { 'atlassian-home':
		ensure => 'directory',
		path => '/opt/atlassian-home',
	} ->
	class { 'nginx': } ->
	class { 'postgresql::globals':
		manage_package_repo => true,
		version             => '9.3',
	}
	class { 'postgresql::server': } ->
	postgresql::server::db { 'jira':
		user     => 'jirauser',
		password => postgresql_password('jirauser', 'jirajira'),
	} ->
	class { 'jira':
		version => '6.3.5',
		installdir => '/opt/atlassian-install/jira',
		homedir => '/opt/atlassian-home/jira',
		dbuser => 'jirauser',
		dbpassword => 'jirajira',
		javahome => '/usr/lib/jvm/java-8-oracle/',
		proxy => {
			scheme => 'http',
			proxyName => 'jira.symbolasd.net',
			proxyPort => '80',
		}
	}

	class { 'jira::facts': }

	nginx::resource::upstream { 'jira':
		members => [ 'localhost:8080' ],
  	}

	nginx::resource::vhost { 'jira.symbolasd.net':
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