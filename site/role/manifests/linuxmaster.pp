class role::linuxmaster {
	include profile::base
	include ::lvm
	include ::aptcacherng
}