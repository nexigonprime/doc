#!/bin/bash

# verificar acesso root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root"
    exit 1
fi

# função para verificar se o sistema está atualizado
check_update() {
    echo "Verificando se o sistema está atualizado..."
    sleep 2
    apt update -y
    apt upgrade -y
}

# função para verificar se o ssh/openssh-server está instalado
check_ssh_installed() {
    echo "Verificando se o ssh/openssh-server está instalado..."
    sleep 2
    if dpkg -l | grep -q openssh-server; then
        echo "O ssh/openssh-server está instalado"
    else
        echo "O ssh/openssh-server não está instalado"
    fi
}

# função para remover ssh/openssh-server e seus diretórios ssh
remove_ssh() {
    echo "Removendo ssh/openssh-server e seus diretórios ssh..."
    sleep 2
    apt remove --purge openssh-server -y
    rm -rf /etc/ssh
    rm -rf /var/lib/ssh
    rm -rf ~/.ssh
}

# função para instalar ssh/openssh-server
install_ssh() {
    echo "Instalando ssh/openssh-server..."
    sleep 2
    apt install -y openssh-server
}

# pergunta se o usuário deseja usar o ssh como root
configure_root_access() {
    echo "Deseja usar o ssh como root? (s/n)"
    read resposta
    if [ "$resposta" = "s" ]; then
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 
        systemctl restart ssh
        echo "O ssh está configurado para usar o root"
        echo "Avisando para dar comando sudo passwd root e colocar uma senha forte"
        sleep 2
        echo "sudo passwd root"
        echo "A senha deve ser forte e não conter caracteres especiais"
    fi
}

# função para fechar o script
close_script() {
    echo "Fechando script..."
    sleep 2
    exit 1
}

# Chamada das funções
check_update
check_ssh_installed
# Adicione chamadas para as outras funções conforme necessário

