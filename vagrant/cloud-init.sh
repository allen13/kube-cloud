#!/bin/bash
set -e

#disable automatic updates
systemctl stop update-engine; systemctl mask update-engine

#setup coreos toolbox to be comptable with ansible
sudo mkdir --parents '/opt/bin'

sudo tee '/opt/bin/python' > /dev/null <<-'EOL'
    #!/bin/bash
    toolbox --quiet --bind=/home:/home python "$@"
EOL

sudo chmod +x '/opt/bin/python'

sudo tee '/root/.toolboxrc' > /dev/null <<-'EOL'
    TOOLBOX_DOCKER_IMAGE=allen13/coreos-ansible-toolbox
    TOOLBOX_DOCKER_TAG=latest
    TOOLBOX_USER=root
EOL

sudo tee '/home/core/.toolboxrc' > /dev/null <<-'EOL'
    TOOLBOX_DOCKER_IMAGE=allen13/coreos-ansible-toolbox
    TOOLBOX_DOCKER_TAG=latest
    TOOLBOX_USER=root
EOL

#change vagrant core password
echo "core:core" | sudo chpasswd

#Get toolbox image ready
docker pull allen13/coreos-ansible-toolbox
