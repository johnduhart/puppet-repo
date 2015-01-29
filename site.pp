node 'linuxmaster' {
	include role::linuxmaster
}

node 'linuxclient' {
	include role::linuxclient
}

node default {
	include profile::base
}