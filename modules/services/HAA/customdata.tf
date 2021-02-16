### HAA ####
data "template_file" "haa-master" {
  template   = <<EOF
#!/bin/bash
sudo su
sudo yum update -y
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^(.*)$/#1/g' /etc/fstab
export LANG="en_US.utf8"
sudo yum install -y wget
wget http://download.uipath.com/haa/2020/2.0/get-haa.sh
sudo chmod +x get-haa.sh
sudo sh get-haa.sh -u ${var.haa-user} -p ${var.haa-password}
EOF
}

data "template_file" "haa-slave" {
  template   = <<EOF
#!/bin/bash
sudo su
sudo yum update -y
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^(.*)$/#1/g' /etc/fstab
export LANG="en_US.utf8"
sudo yum install -y wget
wget http://download.uipath.com/haa/2020/2.0/get-haa.sh
sudo chmod +x get-haa.sh
sudo sh get-haa.sh -u ${var.haa-user} -p ${var.haa-password} -j ${azurerm_network_interface.haa_master_network_interface.private_ip_address}
EOF
}