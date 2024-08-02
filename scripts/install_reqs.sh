#! /bin/bash

#############################
# CHECK TO SEE NETWORK IS READY
#############################
count=0
while true
do
  STATUS=$(curl -s -k -I https://github.com | grep HTTP)
  if [[ $STATUS == *"200"* ]]; then
    echo "internet access check passed"
    break
  elif [ $count -le 360 ]; then
    echo "Status code: $STATUS  Not done yet..."
    count=$[$count+1]
  else
    echo "GIVE UP..."
    break
  fi
  sleep 10
done

sudo timedatectl set-timezone $1
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo apt update
# sudo DEBIAN_FRONTEND=noninteractive apt upgrade -qq
sudo apt  --assume-yes --verbose-versions --allow-change-held-packages -o Dpkg::Options::="--force-confdef" upgrade
sudo apt install -y software-properties-common apt-transport-https wget gpg net-tools nmap

# VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code 

# wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
# sudo apt install -y code

# Postman
sudo snap install postman

# Ansible
sudo apt install -y ansible

# Cleanup
sudo apt -y autoremove

# Suppress Ubuntu LTS upgrade messages
sudo sed -i 's/Prompt=lts/Prompt=never/' /etc/update-manager/release-upgrades
