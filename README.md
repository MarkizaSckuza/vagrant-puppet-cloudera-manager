# vagrant-puppet-cloudera-manager
4 node CM cluster


In Administrator shell run:

  `vagrant up`
 

After installiation go to http://cm.node1.com, user `admin`, password `admin` and install cluster using CM. Detailed installiation here:

  https://www.cloudera.com/documentation/enterprise/latest/topics/install_software_cm_wizard.html#concept_qdy_mz3_wcb


To ssh to any node run, password `vagrant`:

  `ssh root@cm.node<node_num>.com`
