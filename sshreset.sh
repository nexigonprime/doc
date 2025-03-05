#!/bin/bash

# função para exibir mensagens e executar comandos
timer() {
    echo "$1"
    sleep 2
}

# fazer update e upgrade
update_system() {
    timer "Verificando se o sistema está atualizado..."
    apt update -y
    apt upgrade -y
}

# verificar se o ssh/openssh-server está instalado
check_ssh_installed() {
    timer "Verificando se o ssh/openssh-server está instalado..."
    if dpkg -l | grep -q openssh-server; then
        echo "O ssh/openssh-server está instalado"
        return 0  # Retorna 0 se instalado
    else
        echo "O ssh/openssh-server não está instalado"
        return 1  # Retorna 1 se não instalado
    fi
}

# remover ssh/openssh-server e seus diretórios ssh
remove_ssh() {
    timer "Removendo ssh/openssh-server e seus diretórios ssh..."
    read -p "Tem certeza que deseja remover o ssh/openssh-server? (s/n) " confirm
    if [ "$confirm" = "s" ]; then
        apt remove --purge openssh-server -y
        rm -rf /etc/ssh
        rm -rf /var/lib/ssh
        rm -rf ~/.ssh
    else
        echo "Remoção cancelada."
    fi
}

# instalar ssh/openssh-server
install_ssh() {
    timer "Instalando ssh/openssh-server..."
    apt install -y openssh-server
}

# pergunta se o usuário deseja usar o ssh como root
configure_root_access() {
    timer "Deseja usar o ssh como root? (s/n)"
    read resposta
    if [ "$resposta" = "s" ]; then
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 
        systemctl restart ssh
        echo "O ssh está configurado para usar o root"
        echo "Avisando para dar comando 'passwd root' e colocar uma senha forte"
        echo "A senha deve ser forte e não conter caracteres especiais"
    fi
}

# fechar script
close_script() {
    timer "Fechando script..."
    exit 1
}

# Chamada das funções
update_system
if check_ssh_installed; then
    # Se o SSH estiver instalado, pergunte se deseja removê-lo
    remove_ssh
else
    # Se o SSH não estiver instalado, pergunte se deseja instalá-lo
    install_ssh
fi

# Pergunta se o usuário deseja configurar o acesso root
configure_root_access

# Fechar o script
close_script

