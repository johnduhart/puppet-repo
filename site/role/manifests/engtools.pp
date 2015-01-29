class role::engtools {
	include profile::base
	include ::lvm

	lvm::logical_volume { 'atlassian-home':
		volume_group => 'datavg',
		size => '10G',
		mountpath => '/mnt/atlassian-home',
	} ->
	lvm::logical_volume { 'archive':
		volume_group => 'archivevg',
		size => '50G',
		mountpath => '/mnt/archive',
	}
}