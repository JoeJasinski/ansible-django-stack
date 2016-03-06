VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/site.yml"
    #ansible.playbook = "ansible/playbooks/add-user.yml"
    ansible.verbose = "vvvv"
    ansible.extra_vars = {
    #    "user_to_add" => "testb"
         "install_nginx" => true,
         "install_ntp" => true,
         "install_unattended_updates" => true,
         "install_postgis" => true,
         "install_postgres" => true,
         "install_mysql" => true,
    }
    ansible.sudo = true
    ansible.limit = "all"
  end
end
