class role::engtools {
	include profile::base

	class { '::profile::engtools::base': }
	
	class { '::profile::engtools::jira':
		require => Class['::profile::engtools::base'],
	}
	class { '::profile::engtools::stash':
		require => Class['::profile::engtools::base'],
	}
	class { '::profile::engtools::confluence':
		require => Class['::profile::engtools::base'],
	}
}