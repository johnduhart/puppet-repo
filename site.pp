node 'linuxmaster' {
	include role::linuxmaster
}

node 'linuxclient' {
	include role::linuxclient
}

node 'engtools' {
	include role::engtools
}

node 'engtools-db' {
	include role::engtoolsdb
}

node default {
	include profile::base
}