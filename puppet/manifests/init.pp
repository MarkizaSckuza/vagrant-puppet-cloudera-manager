node 'cm.node01.com' {
	include base_install
	include mysql
	include cloudera_install
}

node 'cm.node02.com', 'cm.node03.com', 'cm.node04.com' {
	include base_install
}