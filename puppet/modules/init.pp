class mysql {
  
  $mysql_password = "qedw"

  package { 'mysql-server': ensure => installed }
  package { 'mysql': ensure => installed }

  service { 'mysqld':
    enable => true,
    ensure => running,
    require => Package['mysql-server'],
  }

  # file { "/var/lib/mysql/my.cnf":
  #   owner => "mysql", group => "mysql",
  #   source => "puppet:///mysql/my.cnf",
  #   notify => Service["mysqld"],
  #   require => Package["mysql-server"],
  # }
 
  # file { "/etc/my.cnf":
  #   require => File["/var/lib/mysql/my.cnf"],
  #   ensure => "/var/lib/mysql/my.cnf",
  # }

  exec { 'set-mysql-password':
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password $mysql_password",
    require => Service['mysqld'],
  }

  exec { 'create-db':
      command => "/usr/bin/mysql -uroot -p$mysql_password -e \"CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
                                                               GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm';

                                                               CREATE DATABASE metastore DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
                                                               GRANT ALL ON metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive123';

                                                               CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
                                                               GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hue123';

                                                               CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
                                                               GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rman123';

                                                               CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
                                                               GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie123';\"",
      require => Service['mysqld', 'set-mysql-password'],
    }

    exec { 'prepare_cloudera_db':
        command => "/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm",
        require => Exec['create-db']
    }
}