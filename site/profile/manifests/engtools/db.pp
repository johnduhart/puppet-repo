class profile::engtools::db {
	class { 'postgresql::globals':
		manage_package_repo => true,
		version             => '9.3',
	} ->
	class { 'postgresql::server': } ->
	postgresql::server::tablespace { 'toolsts':
		location => '/mnt/db',
	}
}