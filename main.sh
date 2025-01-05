#!/bin/bash

sudo -i

# 更改文件属性以允许修改
sudo lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
sudo chattr -i /etc/passwd /etc/shadow >/dev/null 2>&1
sudo chattr -a /etc/passwd /etc/shadow >/dev/null 2>&1
sudo lsattr /etc/passwd /etc/shadow >/dev/null 2>&1

# 更改root密码
echo root:$1 | sudo chpasswd root

# 修改SSH配置文件以允许root登录和密码认证
sudo sed -i "s/^#\?Port.*/Port 22/g" /etc/ssh/sshd_config
sudo sed -i "s/^#\?PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
sudo sed -i "s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i 's/^#\?KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config

# 检查并调整ChallengeResponseAuthentication设置
if grep -q "^#ChallengeResponseAuthentication" /etc/ssh/sshd_config; then
    sudo sed -i "s/^#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
elif grep -q "^ChallengeResponseAuthentication" /etc/ssh/sshd_config; then
    sudo sed -i "s/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
else
    echo "ChallengeResponseAuthentication yes" | sudo tee -a /etc/ssh/sshd_config >/dev/null
fi

# 删除authorized_keys文件
sudo rm -f ~/.ssh/authorized_keys

# 重启SSH服务
sudo service ssh restart >/dev/null 2>&1 
sudo service sshd restart >/dev/null 2>&1

# 移除agent
snap remove oracle-cloud-agent
snap remove oracle-cloud-agent-updater

# 修改iptables规则
sudo iptables -P INPUT ACCEPT && sudo iptables -P OUTPUT ACCEPT && sudo iptables -F && sudo iptables-save > /etc/iptables/rules.v4 && sudo ip6tables-save > /etc/iptables/rules.v6 

# 打印成功信息
echo "成功更改当前root密码为：$1"
