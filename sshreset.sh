#!/bin/bash

#dar comando update e upgrade
sudo apt update -y
sudo apt upgrade -y

#remover ssh/openssh-server e seus diretorios ssh
echo "Removendo ssh/openssh-server e seus diretorios ssh..."
sleep 3
sudo apt remove --purge openssh-server -y
sudo rm -rf /etc/ssh
sudo rm -rf /var/lib/ssh
sudo rm -rf ~/.ssh

#instalar ssh/openssh-server
echo "Instalando ssh/openssh-server..."
sleep 3
sudo apt install -y openssh-server

#habilitar o ssh root
echo "Habilitando o ssh root..."
sleep 3
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 
sudo systemctl restart ssh  

#avisar que o ssh root foi habilitado e dar comando passwd root para criar senha
echo "O ssh root foi habilitado com sucesso!"
echo "Execute o comando passwd root para criar a senha do root"

#sleep 3 e fechar o terminal
sleep 3
exit

