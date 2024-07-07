#!/bin/bash

sudo lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
sudo chattr -i /etc/passwd /etc/shadow >/dev/null 2>&1
sudo chattr -a /etc/passwd /etc/shadow >/dev/null 2>&1
sudo lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
echo root:$1 | sudo chpasswd root
sudo sed -i "s/^#\?Port.*/Port 22/g" /etc/ssh/sshd_config;
sudo sed -i "s/^#\?PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config;
sudo sed -i "s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config;
sudo sed -i 's/^#\?KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config
sudo rm ~/.ssh/authorized_keys
sudo service ssh restart >/dev/null 2>&1 
sudo service sshd restart >/dev/null 2>&1
sudo iptables -P INPUT ACCEPT && sudo iptables -P OUTPUT ACCEPT && sudo iptables -F && sudo iptables-save > /etc/iptables/rules.v4 && sudo ip6tables-save > /etc/iptables/rules.v6 
echo "成功更改当前root密码为：$1"
