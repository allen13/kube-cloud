# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'
require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  create_coreos_vm(config, name: "coreos", id: 1, cpus: 2, memory: 3072, cloud_config: 'vagrant/cloud-config-master.yml')
  create_coreos_vm(config, name: "coreos", id: 2, cpus: 1, memory: 1024, cloud_config: 'vagrant/cloud-config-worker.yml')
end
