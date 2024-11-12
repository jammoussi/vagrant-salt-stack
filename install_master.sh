#!/bin/bash

###############################################################
#  TITRE: 
#
#  AUTEUR:   Xavier
#  VERSION: 
#  CREATION:  
#  MODIFIE: 
#
#  DESCRIPTION: 
###############################################################



# Variables ###################################################



# Functions ###################################################



# Let's Go !! #################################################


#curl -sL https://bootstrap.saltstack.com -o install_salt.sh 2>&1 >/dev/null 
#curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
#chmod 755 install_salt.sh
#sudo sh install_salt.sh -P -M 2>&1 >/dev/null
mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources

echo 'Package: salt-*
Pin: version 3006.*
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/salt-pin-1001

sudo apt-get install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api -y
#sudo sh bootstrap-salt.sh -P stable 3006.1
sudo mkdir -p /srv/{salt,pillar}/base
sudo chown -R vagrant:vagrant  /srv/
sudo chmod 775 -R   /srv/

echo "
auto_accept: True
file_roots:
  base:
    - /srv/salt/base/
pillar_roots:
  base:
    - /srv/pillar/base
" >> /etc/salt/master

echo "
master: 127.0.0.1
" > /etc/salt/minion

sudo systemctl restart salt-master
sudo systemctl restart salt-minion
