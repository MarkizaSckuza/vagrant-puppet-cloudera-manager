class cloudera_install {

	include ::stdlib

	exec { 'wget_cm':
	  command => "/usr/bin/wget https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/",
	}

	exec { 'rpm_import':
		require => Exec['wget_cm'],
	  	command => "/usr/bin/rpm --import https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/RPM-GPG-KEY-cloudera",
	}

	package { 'oracle-j2sdk1.8':
		require => Exec['rpm_import'],
		ensure => installed,
		provider => 'yum',
	}

	package { ['cloudera-manager-daemons', 'cloudera-manager-agent', 'cloudera-manager-server']:
		require => Exec['rpm_import'],
		ensure => installed,
		provider => 'yum',
	}

	file { '/etc/default/cloudera-scm-server':
	  	ensure => present,
	  	require => Package['cloudera-manager-daemons', 'cloudera-manager-agent', 'cloudera-manager-server'],
	}->
	file_line { 'Change line in /etc/default/cloudera-scm-server':
	  path => '/etc/default/cloudera-scm-server',  
	  line => 'export CMF_JAVA_OPTS="-Xmx4G -XX:MaxPermSize=1024m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp"',
	  match => "^export CMF_JAVA_OPTS.*",
	}

	file { "/etc/environment":
		ensure => present,
        content => inline_template("JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera"),
    }

    exec { 'rm_prev_cert':
    	require => File['/etc/environment'],
    	command => "rm -r -f /opt/cloudera/CMCA",
    	path => ['/usr/bin', '/usr/sbin'],
    }

    exec { 'enable_tls':
		require => Exec['rm_prev_cert'],
		environment => ["JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera"],
		command => "/opt/cloudera/cm-agent/bin/certmanager --location /opt/cloudera/CMCA setup --configure-services",
	}

	exec { 'prepare_cloudera_db':
        command => "/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm",
        require => Exec['enable_tls']
    }

    service { 'cloudera-scm-server':
	    ensure  => 'running',
	    enable  => false,
	    require => Exec['prepare_cloudera_db'],
	}

	# class { '::mysql::server':
	#   root_password           => 'qedw',
	#   remove_default_accounts => false,
	# }

	# mysql::db { 'metastore':
	#   user     => 'hive',
	#   password => 'hive',
	#   host     => '10.211.55.100',
	#   grant    => ['ALL'],
	# }

	# mysql::db { 'scm':
	#   user     => 'scm',
	#   password => 'scm',
	#   host     => '10.211.55.100',
	#   grant    => ['ALL'],
	# }

	# mysql::db { 'hue':
	#   user     => 'hue',
	#   password => 'hue',
	#   host     => '10.211.55.100',
	#   grant    => ['ALL'],
	# }

	# mysql::db { 'rman':
	#   user     => 'rman',
	#   password => 'rman',
	#   host     => '10.211.55.100',
	#   grant    => ['ALL'],
	# }

	# mysql::db { 'oozie':
	#   user     => 'oozie',
	#   password => 'oozie',
	#   host     => '10.211.55.100',
	#   grant    => ['ALL'],
	# }

	# exec { 'prepare_cloudera_db':
	# 	onlyif => "/usr/bin/mysql -uscm -pscm scm",
 #        command => "/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm",
 #    }
}