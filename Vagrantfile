$hosts_script = <<SCRIPT
cat > /etc/hosts <<EOF
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

EOF
SCRIPT

Vagrant.configure("2") do |config|

  # Define base image
  config.vm.box = "bento/centos-7"

  # Manage /etc/hosts on host and VMs
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = false

  config.vm.define :master_6_2_0 do |master_6_2_0|
    master_6_2_0.vm.provider :virtualbox do |v|
      v.name = "master_6_2_0"
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    master_6_2_0.vm.network :private_network, ip: "10.211.55.200"
    master_6_2_0.vm.hostname = "cm.node01.com"
    master_6_2_0.vm.provision :shell, :inline => $hosts_script
    master_6_2_0.vm.provision :hostmanager

    master_6_2_0.vm.provision "shell", path: "./bootstrap.sh"

    master_6_2_0.vm.provision "shell", inline: <<-SHELL
    mkdir -p /etc/puppet/modules;
    puppet module install puppetlabs-stdlib --version 5.2.0;
    SHELL

    master_6_2_0.vm.provision "puppet" do |puppet|
    	puppet.module_path = "puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "./init.pp"
      puppet.options = "--verbose --debug"
  	end
  end

  config.vm.define :slave1_6_2_0 do |slave1_6_2_0|
    slave1_6_2_0.vm.box = "bento/centos-7"
    slave1_6_2_0.vm.provider :virtualbox do |v|
      v.name = "slave1_6_2_0"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave1_6_2_0.vm.network :private_network, ip: "10.211.55.201"
    slave1_6_2_0.vm.hostname = "cm.node02.com"
    slave1_6_2_0.vm.provision :shell, :inline => $hosts_script
    slave1_6_2_0.vm.provision :hostmanager

  	slave1_6_2_0.vm.provision "shell", path: "./bootstrap.sh"

  	slave1_6_2_0.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave1_6_2_0.vm.provision "puppet" do |puppet|
    	puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
    	puppet.options = "--verbose --debug"
  	end
  end

  config.vm.define :slave2_6_2_0 do |slave2_6_2_0|
    slave2_6_2_0.vm.box = "bento/centos-7"
    slave2_6_2_0.vm.provider :virtualbox do |v|
      v.name = "slave2_6_2_0"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave2_6_2_0.vm.network :private_network, ip: "10.211.55.202"
    slave2_6_2_0.vm.hostname = "cm.node03.com"
    slave2_6_2_0.vm.provision :shell, :inline => $hosts_script
    slave2_6_2_0.vm.provision :hostmanager

    slave2_6_2_0.vm.provision "shell", path: "./bootstrap.sh"

    slave2_6_2_0.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave2_6_2_0.vm.provision "puppet" do |puppet|
      puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

  config.vm.define :slave3_6_2_0 do |slave3_6_2_0|
    # slave3.vm.box = "precise64"
    slave3_6_2_0.vm.box = "bento/centos-7"
    slave3_6_2_0.vm.provider :virtualbox do |v|
      v.name = "slave3_6_2_0"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave3_6_2_0.vm.network :private_network, ip: "10.211.55.203"
    slave3_6_2_0.vm.hostname = "cm.node04.com"
    slave3_6_2_0.vm.provision :shell, :inline => $hosts_script
    slave3_6_2_0.vm.provision :hostmanager

    slave3_6_2_0.vm.provision "shell", path: "./bootstrap.sh"

    slave3_6_2_0.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave3_6_2_0.vm.provision "puppet" do |puppet|
      puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end
end