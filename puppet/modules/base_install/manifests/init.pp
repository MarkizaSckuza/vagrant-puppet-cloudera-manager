class base_install {

	include ::stdlib

	exec { 'yum-update':
		command => '/usr/bin/yum -y update'
	}

	service { 'firewalld':
		ensure => 'stopped',
		enable => 'false'
	}

	service { 'sshd':
	    ensure  => 'running',
	    enable  => true,
	}

	File['/etc/ssh/sshd_config'] ~> Service['sshd']

	file { '/etc/ssh/sshd_config':
	  ensure => present,
	}->
	file_line { 'Append a line to /etc/ssh/sshd_config':
	  path => '/etc/ssh/sshd_config',  
	  line => 'PermitRootLogin yes',
	}

	exec {'transparent-hugepages':
		command => '/usr/bin/echo never > /sys/kernel/mm/transparent_hugepage/defrag &&
					/usr/bin/echo never > /sys/kernel/mm/transparent_hugepage/enabled &&
					/usr/sbin/sysctl vm.swappiness=0 && sudo echo \'vm.swappiness = 0\' | sudo tee -a /etc/sysctl.conf;'
	}

	exec { 'wget_mysql_connector':
	  	command => "/usr/bin/wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz",
	}

	exec { 'unzip_mysql_connector':
		command => "tar zxvf mysql-connector-java-5.1.46.tar.gz",
		path => ['/usr/bin', '/usr/sbin'],
		require => Exec['wget_mysql_connector'],
	}

	exec { 'cp_mysql_connector':
		command => "mkdir -p /usr/share/java/ && cd mysql-connector-java-5.1.46 && cp mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar",
        path => ['/usr/bin', '/usr/sbin'],
        require => Exec['wget_mysql_connector', 'unzip_mysql_connector'],
	}
}