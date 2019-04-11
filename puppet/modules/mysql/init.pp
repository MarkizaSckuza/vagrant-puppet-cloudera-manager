class mysql {
  
  $mysql_password = "qedw"

  exec { 'wget_mysql':
    command => "/usr/bin/wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm",
  }

  exec { 'rpm_mysql':
    require => Exec['wget_mysql'],
      command => "/usr/bin/rpm -ivh mysql-community-release-el7-5.noarch.rpm",
  }

  exec { 'yum_update':
    require => Exec['rpm_mysql'],
    command => '/usr/bin/yum -y update'
  }

  package { 'mysql-server':
    require => Exec['yum_update'],
    ensure => installed,
    provider => 'yum',
  }

  service { 'mysqld':
    enable => true,
    ensure => running,
    require => Package['mysql-server'],
  }

  exec { 'mysql_secure_installiation':
    path => ["/bin", "/usr/bin"],
    command => "mysql --user=root -e \"
    UPDATE mysql.user SET Password=PASSWORD('${mysql_password}') WHERE User='root';
    DELETE FROM mysql.user WHERE User='';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'cm\.node[0-9]\.com' IDENTIFIED BY '${mysql_password}' WITH GRANT OPTION;
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;\"",
    require => Service['mysqld'],
  }

  exec { 'create_db':
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
      require => [Service['mysqld'], Exec['mysql_secure_installiation']],
    }
  }