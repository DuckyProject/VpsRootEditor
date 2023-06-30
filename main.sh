#!/bin/bash
echo root:$1 | sudo chpasswd root
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
sudo rm ~/.ssh/authorized_keys
iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT &&  iptables -F && iptables-save > /etc/iptables/rules.v4 && ip6tables-save > /etc/iptables/rules.v6 
echo "成功更改当前root密码为：$1"
