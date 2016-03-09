# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  create_atomic_vm(config, name: "atomic", id: 1, cpus: 2, memory: 3072)
  create_atomic_vm(config, name: "atomic", id: 2, cpus: 1, memory: 1024)
end
