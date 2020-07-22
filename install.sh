#!/bin/bash

## Update , install common packages for Kafka Cluster
echo -e "\e[1;31m configure Hosts file for your enviroment  \e[0m"
sudo echo -e "172.20.20.11  kafka-tools 
172.20.20.21   kafka1 zookeeper1 
172.20.20.22   kafka2 zookeeper2
172.20.20.23   kafka3 zookeeper3" |  sudo tee --append /etc/hosts

echo -e "\e[1;31m change sshd config for vagrant box and restart service  \e[0m"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/UseDNS no/UseDNS yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo -e "\e[1;31m change root pass  \e[0m"
#sudo echo "root" | sudo passwd --stdin root

echo -e "\e[1;31m update and install packages  \e[0m"
sudo apt-get update -y &&  sudo apt-get install vim netcat wget ca-certificates zip net-tools nano tar netcat jq -y
