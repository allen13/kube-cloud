UPDATE_CHANNEL = 'alpha'
IMAGE_VERSION = 'current'

CLUSTER_IP="10.3.0.1"
NODE_IP = "192.168.8.201"
SSL_TARBALL_PATH = File.expand_path("ssl/controller.tar")

system("mkdir -p ssl && vagrant/init-ssl-ca ssl") or abort ("failed generating SSL CA artifacts")
system("vagrant/init-ssl ssl apiserver controller IP.1=#{NODE_IP},IP.2=#{CLUSTER_IP}") or abort ("failed generating SSL certificate artifacts")
system("vagrant/init-ssl ssl admin kube-admin") or abort("failed generating admin SSL artifacts")

def create_coreos_vm(config, options = {})
  dirname = File.dirname(__FILE__)
  config.vm.synced_folder "#{dirname}/..", '/vagrant', disabled: true

  name = options.fetch(:name, "node")
  id = options.fetch(:id, 1)
  vm_name = "%s-%02d" % [name, id]
  cloud_config = options.fetch(:cloud_config, 'vagrant/cloud-config.yml')

  memory = options.fetch(:memory, 1024)
  cpus = options.fetch(:cpus, 1)

  config.vm.define vm_name do |config|
    config.vm.box = "coreos-#{UPDATE_CHANNEL}"
    if IMAGE_VERSION != 'current'
        config.vm.box_version = $image_version
    end
    config.vm.box_url = "http://#{UPDATE_CHANNEL}.release.core-os.net/amd64-usr/#{IMAGE_VERSION}/coreos_production_vagrant.json"

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

    config.vm.provision :file, :source => cloud_config, :destination => "/tmp/vagrantfile-user-data"
    config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
    config.vm.provision :file, :source => SSL_TARBALL_PATH, :destination => "/tmp/ssl.tar"
    config.vm.provision :shell, :inline => "mkdir -p /etc/kubernetes/ssl && tar -C /etc/kubernetes/ssl -xf /tmp/ssl.tar", :privileged => true
    config.vm.provision :shell, :inline => 'echo "core:core" | sudo chpasswd'

    yield(config) if block_given?
  end

end
