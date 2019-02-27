node 'vm-cluster-node1' {
	include base_install
	include mysql
	include cloudera_install
}

node 'vm-cluster-node2', 'vm-cluster-node3', 'vm-cluster-node4' {
	include base_install
}