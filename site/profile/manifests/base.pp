class profile::base {
	include ::apt
	file { '10oracle-proxy':
		ensure  => present,
		path    => "${apt::params::apt_conf_d}/10oracle-proxy",
		content => "Acquire::http::Proxy { download.oracle.com DIRECT; };",
		notify  => Exec['apt_update'],
		mode    => '0644',
		owner   => root,
		group   => root,
	}

	include ::ntp
	include ::ssh::server
}
