class role::engtoolsdb {
	include profile::base
	include ::lvm

	lvm::logical_volume { 'db':
		volume_group => 'datavg',
		size => '20G',
		mountpath => '/mnt/db',
	} ->
	class { 'postgresql::globals':
		manage_package_repo => true,
		version             => '9.3',
	} ->
	class { 'postgresql::server': } ->
	postgresql::server::tablespace { 'toolsts':
		location => '/mnt/db',
	}
}