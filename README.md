kube-cloud
=======================

A [Kubernetes](http://kubernetes.io/docs/)/[Openshift](https://docs.openshift.org/latest/welcome/index.html) driven container cloud. This is a simplified version of [openshift-ansible](https://github.com/openshift/openshift-ansible) that only targets [Fedora Atomic](http://www.projectatomic.io/download/).

####Setup

Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](http://www.vagrantup.com/downloads), and [Ansible](http://docs.ansible.com/ansible/intro_installation.html) on your local machine.

####Running in vagrant

    vagrant up
    bin/provision_development
    go to http://192.168.8.201:8443 login: admin password: (will take any passoword)

####Destroying

    bin/destroy
