#!/bin/sh
sudo cp /vagrant/config/environment /etc/environment
sudo locale-gen zh_CN.UTF-8
sudo dpkg-reconfigure locales
sudo timedatectl set-timezone Asia/Shanghai
source /etc/environment
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-cache policy docker-engine
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y docker-engine python-pip
sudo pip install docker-compose
