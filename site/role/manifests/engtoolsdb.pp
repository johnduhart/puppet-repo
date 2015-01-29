class role::engtoolsdb {
	include profile::base
	include ::lvm

	lvm::logical_volume { 'db':
		volume_group => 'datavg',
		size => '20G',
		mountpath => '/mnt/db',
	} ->
	class { '::profile::engtools::db': } ->
	class { '::profile::engtools::jiradb': }
}