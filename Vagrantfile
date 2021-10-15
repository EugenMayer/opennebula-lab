# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  public_key = File.read("sshkeys/id_rsa.pub")
  private_key = File.read("sshkeys/id_rsa")

  config.vm.synced_folder "./", "/share", create: true

  config.vm.box = "debian/contrib-buster64"

  config.vm.network "private_network", type: "dhcp"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if vm.id
      read_ip_address(vm)
    end
  end
  
  # controller / frontend
  config.vm.define :frontend do |box|
    box.vm.provider :virtualbox do |vb|
      vb.memory = 3048
      vb.cpus = 3
    end
    box.vm.host_name = "frontend"
    box.vm.network "forwarded_port", guest: 80, host: 9080
    box.vm.provision "shell", path: "bootstrap.sh"
    box.vm.provision "shell", inline: <<-SCRIPT
        sudo mkdir -p /root/.ssh
        sudo chmod 700 /root/.ssh
        sudo echo '#{private_key}' >> /root/.ssh/id_rsa
        sudo echo '#{public_key}' >> /root/.ssh/id_rsa.pub
        sudo chmod -R 600 /root/.ssh/id_rsa
        sudo chmod -R 600 /root/.ssh/id_rsa.pub
        SCRIPT
  end

  # first compute box
  config.vm.define :compute1 do |box|
    box.vm.provider :virtualbox do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end
    box.vm.host_name = "compute1"
    box.vm.provision "shell", path: "bootstrap_compute.sh"
    box.vm.provision "shell", inline: <<-SCRIPT
      sudo mkdir -p /root/.ssh
      sudo chmod 700 /root/.ssh
      sudo echo '#{public_key}' >> /root/.ssh/authorized_keys
      sudo chmod -R 600 /root/.ssh/authorized_keys
      SCRIPT
  end

  # second compute box
  config.vm.define :compute2 do |box|
    box.vm.provider :virtualbox do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end
    box.vm.host_name = "compute2"
    box.vm.provision "shell", path: "bootstrap_compute.sh"
    box.vm.provision "shell", inline: <<-SCRIPT
      sudo mkdir -p /root/.ssh
      sudo chmod 700 /root/.ssh
      sudo echo '#{public_key}' >> /root/.ssh/authorized_keys
      sudo chmod -R 600 /root/.ssh/authorized_keys
      SCRIPT
  end
end

$logger = Log4r::Logger.new('vagrantfile')
def read_ip_address(machine)
  command =  "ip a | grep 'inet' | grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2 }' | cut -f1 -d\"/\""
  result  = ""

  $logger.info "Processing #{ machine.name } ... "

  begin
    # sudo is needed for ifconfig
    machine.communicate.sudo(command) do |type, data|
      result << data if type == :stdout
    end
    $logger.info "Processing #{ machine.name } ... success"
  rescue
    result = "# NOT-UP"
    $logger.info "Processing #{ machine.name } ... not running"
  end

  # the second inet is more accurate
  result.chomp.split("\n").select { |hash| hash != "" }[1]
end