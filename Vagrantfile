# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
FORWARD_PORTS = {
  3000 => 3000,  # thin
  15_432 => 5432 # PostgreSQL
}

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"

  config.vm.provision :shell, path: "provision.sh", privileged: false

  FORWARD_PORTS.each do |host, guest|
    config.vm.network :forwarded_port, host: host, guest: guest
  end
end
