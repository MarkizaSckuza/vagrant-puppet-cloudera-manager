node 'cm.node1.com' {
	include base_install
	include mysql
	include cloudera_install
}

node 'cm.node2.com', 'cm.node3.com', 'cm.node4.com' {
	include base_install
}