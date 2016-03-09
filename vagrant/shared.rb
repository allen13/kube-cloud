ATOMIC_BOX = "fedora/23-atomic-host"

def create_atomic_vm(config, options = {})
  name = options.fetch(:name, "node")
  id = options.fetch(:id, 1)
  vm_name = "%s-%02d" % [name, id]

  memory = options.fetch(:memory, 1024)
  cpus = options.fetch(:cpus, 1)

  config.vm.define vm_name do |config|
    config.vm.box = ATOMIC_BOX
    config.vm.hostname = vm_name

    public_ip = "192.168.8.20#{id}"
    config.vm.network :private_network, ip: public_ip, netmask: "255.255.255.0"

    config.vm.provider :virtualbox do |vb|
      vb.memory = memory
      vb.cpus = cpus
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.check_guest_additions = false
      vb.functional_vboxsf     = false
    end
  end
end
