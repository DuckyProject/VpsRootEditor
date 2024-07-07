#!/bin/bash

# 确保脚本以root权限运行
if [ "$EUID" -ne 0 ]; then
    echo "请使用sudo或以root权限运行此脚本"
    exit 1
fi

# 更改root密码
echo root:$1 | sudo chpasswd root
# 修改SSH配置文件以允许root登录和密码认证
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# 重启SSH服务
sudo service sshd restart
# 删除authorized_keys文件
sudo rm ~/.ssh/authorized_keys
# 修改iptables规则
sudo iptables -P INPUT ACCEPT && sudo iptables -P OUTPUT ACCEPT && sudo iptables -F && sudo iptables-save > /etc/iptables/rules.v4 && sudo ip6tables-save > /etc/iptables/rules.v6 
# 打印成功信息
echo "成功更改当前root密码为：$1"
