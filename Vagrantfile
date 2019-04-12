# Vagrant.configure("2") do |config|
#   config.vm.box = "centos/7"
#   config.vm.network "forwarded_port", guest: 80, host: 8084
#   ####### Install Puppet Agent #######
#   config.vm.provision "shell", path: "./bootstrap.sh"
#   ####### Provision #######
#   config.vm.provision "puppet" do |puppet|
#     puppet.module_path = "./site"
#     puppet.options = "--verbose --debug"
#   end
# end

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
  # config.vm.box = "precise64"
  config.vm.box = "bento/centos-7"

  # Manage /etc/hosts on host and VMs
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = false

  config.vm.define :master do |master|
    master.vm.provider :virtualbox do |v|
      v.name = "master"
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    master.vm.network :private_network, ip: "10.211.55.100"
    master.vm.hostname = "cm.node1.com"
    master.vm.provision :shell, :inline => $hosts_script
    master.vm.provision :hostmanager

    master.vm.provision "shell", path: "./bootstrap.sh"

    master.vm.provision "shell", inline: <<-SHELL
    mkdir -p /etc/puppet/modules;
    puppet module install puppetlabs-stdlib --version 5.2.0;
    SHELL

    master.vm.provision "puppet" do |puppet|
    	puppet.module_path = "puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "./init.pp"
      puppet.options = "--verbose --debug"
  	end
  end

  config.vm.define :slave1 do |slave1|
    slave1.vm.box = "bento/centos-7"
    slave1.vm.provider :virtualbox do |v|
      v.name = "slave1"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave1.vm.network :private_network, ip: "10.211.55.101"
    slave1.vm.hostname = "cm.node2.com"
    slave1.vm.provision :shell, :inline => $hosts_script
    slave1.vm.provision :hostmanager

  	slave1.vm.provision "shell", path: "./bootstrap.sh"

  	slave1.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave1.vm.provision "puppet" do |puppet|
    	puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
    	puppet.options = "--verbose --debug"
  	end
  end

  config.vm.define :slave2 do |slave2|
    slave2.vm.box = "bento/centos-7"
    slave2.vm.provider :virtualbox do |v|
      v.name = "slave2"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave2.vm.network :private_network, ip: "10.211.55.102"
    slave2.vm.hostname = "cm.node3.com"
    slave2.vm.provision :shell, :inline => $hosts_script
    slave2.vm.provision :hostmanager

    slave2.vm.provision "shell", path: "./bootstrap.sh"

    slave2.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave2.vm.provision "puppet" do |puppet|
      puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

  config.vm.define :slave3 do |slave3|
    slave3.vm.box = "bento/centos-7"
    slave3.vm.provider :virtualbox do |v|
      v.name = "slave3"
      v.customize ["modifyvm", :id, "--memory", "6144", "--cpus", "2"]
    end
    slave3.vm.network :private_network, ip: "10.211.55.103"
    slave3.vm.hostname = "cm.node4.com"
    slave3.vm.provision :shell, :inline => $hosts_script
    slave3.vm.provision :hostmanager

    slave3.vm.provision "shell", path: "./bootstrap.sh"

    slave3.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-stdlib --version 5.2.0
      SHELL

    slave3.vm.provision "puppet" do |puppet|
      puppet.module_path = "./puppet/modules"
      puppet.manifests_path = "./puppet/manifests"
      puppet.manifest_file  = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end
end