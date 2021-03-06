class profile::engtools::base {
	include ::lvm
	class { '::java::oracle_1_8_0': }
	class { '::nginx': }

	lvm::logical_volume { 'atlassian-home':
		volume_group => 'datavg',
		size => '10G',
		mountpath => '/mnt/atlassian-home',
	} ->
	lvm::logical_volume { 'archive':
		volume_group => 'archivevg',
		size => '50G',
		mountpath => '/mnt/archive',
	} ->
	file { 'atlassian-install':
		ensure => 'directory',
		path => '/opt/atlassian-install',
	}
}