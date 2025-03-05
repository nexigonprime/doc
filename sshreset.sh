#!/bin/bash

# verificar acesso root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root"
    exit 1
fi

#fazer update e upgrade
timer() {
    echo "Verificando se o sistema esta atualizado..."
    sleep 2
    sudo apt update -y
    sudo apt upgrade -y
}

#verificar se o ssh/openssh-server esta instalado
timer() {
    echo "Verificando se o ssh/openssh-server esta instalado..."
    sleep 2
    if [ -f /etc/ssh/sshd_config ]; then
        echo "O ssh/openssh-server esta instalado"
    else
        echo "O ssh/openssh-server nao esta instalado"
    fi
}

#remover ssh/openssh-server e seus diretorios ssh
timer() {
    echo "Removendo ssh/openssh-server e seus diretorios ssh..."
    sleep 2
    sudo apt remove --purge openssh-server
    sudo rm -rf /etc/ssh
    sudo rm -rf /var/lib/ssh
    sudo rm -rf ~/.ssh
}

#instalar ssh/openssh-server
timer() {
    echo "Instalando ssh/openssh-server..."
    sleep 2
    sudo apt install -y openssh-server
}

#pergunta se o usuario que usar o ssh como root
timer() {
    echo "Deseja usar o ssh como root? (s/n)"
    read resposta
    if [ "$resposta" = "s" ]; then
        sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
        sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 
        sudo systemctl restart ssh
        echo "O ssh esta configurado para usar o root"
        #avisar para dar comando sudo passwd root e colocar uma senha forte
        echo "Avisando para dar comando sudo passwd root e colocar uma senha forte"
        sleep 2
        echo "sudo passwd root"
        echo "A senha deve ser forte e nao conter caracteres especiais"
    fi
}
fechar script
timer() {
    echo "Fechando script..."
    sleep 2
    exit 1
}

