# -*- mode: ruby -*-
# vi: set ft=ruby :

computeNodes = {
  'compute1' => {'hostname' => 'compute1'},
  'compute2' => {'hostname' => 'compute2'}
}

Vagrant.configure("2") do |config|
  # get our pre-generated ssh keys
  if Dir.exist?('sshkeys') 
    public_key = File.read("sshkeys/id_rsa.pub")
    private_key = File.read("sshkeys/id_rsa")
  end
 

  config.vm.box = "debian/contrib-buster64"

  # ensure our hosts can resolve themselfs via hostnames 
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
    box.vm.network "forwarded_port", guest: 80, host: 8080
    box.vm.network "forwarded_port", guest: 2616, host: 2616
  
    
    # install opennebula via minione
    box.vm.provision "shell", path: "bootstrap_frontend.sh"

    # deploy ssh private/public key before we install
    box.vm.provision "shell", inline: <<-SCRIPT
      #sudo useradd oneadmin -d /var/lib/one -m
      #sudo mkdir -p /var/lib/one/.ssh
      #sudo chmod u=rwx,g=,o= /var/lib/one/.ssh
      sudo echo '#{private_key}' > /var/lib/one/.ssh/id_rsa
      sudo echo '#{public_key}' > /var/lib/one/.ssh/id_rsa.pub
      sudo echo '#{public_key}' >> /var/lib/one/.ssh/authorized_keys
      sudo chmod -R 600 /var/lib/one/.ssh/id_rsa
      sudo chmod -R 600 /var/lib/one/.ssh/id_rsa.pub
      sudo chmod -R 600 /var/lib/one/.ssh/authorized_keys
      sudo chown oneadmin:oneadmin /var/lib/one/ -R
      SCRIPT

    # ensure our ssh keys are properly picked up
    box.vm.provision "shell", inline: "sudo systemctl restart opennebula-ssh-agent.service"
  end

  computeNodes.keys.sort.each do |key|
    hostname = computeNodes[key]['hostname']
    config.vm.define hostname do |box|
      box.vm.provider :virtualbox do |vb|
        vb.memory = 2048
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
      end
      box.vm.host_name = hostname
      box.vm.provision "shell", path: "bootstrap_compute.sh"
      # deploy the ssh key of frontend
      box.vm.provision "shell", inline: <<-SCRIPT
        sudo mkdir -p /var/lib/one/.ssh
        sudo chmod u=rwx,g=,o= /var/lib/one/.ssh
        sudo echo '#{public_key}' >> /var/lib/one/.ssh/authorized_keys
        sudo chmod -R 600 /var/lib/one/.ssh/authorized_keys
        sudo chown oneadmin:oneadmin /var/lib/one/ -R
        SCRIPT
    end
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