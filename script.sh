#!/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
ami=`whoami`
version=`grep -Po "(?<=^ID=).+" /etc/os-release | sed 's/"//g'`

security_pkg() {
    #Installation de Fail2ban
    echo -e "${GREEN}Installation de Fail2ban...${NC}"
    apt install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban

    #Installation de ClamAV
    echo -e "${GREEN}Installation de ClamAV...${NC}"
    apt install -y clamav clamav-daemon
    freshclam
    systemctl enable clamav-freshclam
    systemctl enable clamav-daemon
    systemctl start clamav-freshclam
    systemctl start clamav-daemon
}

backup() {
    # Définition des couleurs
    GREEN="\e[32m"
    RED="\e[31m"
    NC="\e[0m"

    # Définition du nom du fichier de backup avec timestamp
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    local_backup="/tmp/backup_$TIMESTAMP.img.gz"

    # Demande à l'utilisateur son choix
    echo -e "${GREEN}Backup du serveur...${NC}"
    read -p "Voulez-vous faire une backup et l'envoyer sur une machine distante ou enregistrer en local ? (distante/local) : " choice

    # Vérification de l’espace disque avant la sauvegarde
    free_space=$(df /tmp | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt 10000000 ]; then
        echo -e "${RED}Erreur : Espace disque insuffisant pour la sauvegarde.${NC}"
        exit 1
    fi

    # Sauvegarde distante
    if [[ "$choice" == "distante" ]]; then
        echo -e "${GREEN}Backup distante...${NC}"
        read -p "Adresse IP de la machine distante : " ip
        read -p "Nom d'utilisateur : " user
        read -p "Chemin de destination : " path

        echo -e "${GREEN}Création de l'image du disque compressée...${NC}"
        dd if=/dev/sda bs=64K status=progress | gzip > "$local_backup"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Backup locale réussie.${NC}"
            echo -e "${GREEN}Envoi de la backup sur la machine distante...${NC}"
            scp "$local_backup" "$user@$ip:$path"

            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Backup distante réussie.${NC}"
                rm "$local_backup"
            else
                echo -e "${RED}Échec de l'envoi de la backup distante.${NC}"
            fi
        else
            echo -e "${RED}Échec de la création de l'image du disque.${NC}"
        fi

    # Sauvegarde locale
    elif [[ "$choice" == "local" ]]; then
        echo -e "${GREEN}Backup locale...${NC}"
        read -p "Chemin de destination : " path
        mkdir -p "$path"

        echo -e "${GREEN}Création de l'image du disque compressée...${NC}"
        dd if=/dev/sda bs=64K status=progress | gzip > "$path/backup_$TIMESTAMP.img.gz"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Backup locale réussie : $path/backup_$TIMESTAMP.img.gz${NC}"
        else
            echo -e "${RED}Échec de la création de l'image du disque.${NC}"
        fi

    else
        echo -e "${RED}Choix invalide.${NC}"
    fi
}



restore_backup() {
    echo -e "${GREEN}Restauration de la sauvegarde...${NC}"
    read -p "Chemin de la sauvegarde à restaurer : " backup_path
    
    if [ ! -f "$backup_path" ]; then
        echo -e "${RED}Erreur : Le fichier de sauvegarde n'existe pas.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Décompression de l'image du disque...${NC}"
    gunzip -c "$backup_path" | dd of=/dev/sda bs=64K status=progress
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Restauration réussie.${NC}"
    else
        echo -e "${RED}Échec de la restauration de l'image du disque.${NC}"
    fi
}

enssential_pkg() {

# script for install docker credit S4dic -> https://github.com/s4dic

case $version in
  ubuntu)
	if [[ "$ami" != "root" ]]; then
		echo "Please login with root account for Ubuntu"
		exit 0
	fi
    apt remove -y docker docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose docker-scan-plugin docker-engine docker.io containerd runc
    apt install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt update && chmod a+r /etc/apt/keyrings/docker.gpg && apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-scan-plugin
  curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  chmod +x /usr/bin/docker-compose
    echo "vérification de la version docker + docker compose installée:"
    docker --version
    docker-compose --version
    echo "fin de l'installation"
    ;;
  debian)
	if [[ "$ami" != "root" ]]; then
		echo "Please login with root account for Debian"
		exit 0
	fi
    apt remove -y docker docker-ce docker-ce-cli docker-ce-rootless-extras docker-compose docker.io containerd runc
    apt update && apt install -y ca-certificates curl gnupg lsb-release && mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  	apt update && chmod a+r /etc/apt/keyrings/docker.gpg && apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-scan-plugin
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
    echo "";echo "";echo "";echo "";
    echo "vérification de la version docker + docker compose installée:"
    docker --version
    docker-compose --version
    echo "";
    echo "fin de l'installation"
    ;;
  *)
    echo "version non reconnue"
    ;;
esac

}


# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Ce script doit être exécuté en tant que root.${NC}"
    exit 1
fi

while true; do
    cat << EOF

                                                              
    @@@@@@@  @@@@@@   @@@@@@  @@@      @@@@@@@   @@@@@@  @@@  @@@ 
      @!!   @@!  @@@ @@!  @@@ @@!      @@!  @@@ @@!  @@@ @@!  !@@ 
      @!!   @!@  !@! @!@  !@! @!!      @!@!@!@  @!@  !@!  !@@!@!  
      !!:   !!:  !!! !!:  !!! !!:      !!:  !!! !!:  !!!  !: :!!  
       :     : :. :   : :. :  : ::.: : :: : ::   : :. :  :::  :::

       v1.0.0
                                                              

    ToolBox facilite l'installation de paquet essentiel pour 
    votre serveur.

    1. Télechargé les paquets essentiels 
    2. Téléchargé les paquets essentiels de sécurité
    3. Faire une backup du serveur
    4. Restaurer une backup
    99. Quitter
EOF

    read -p "-> " REPLY

    case $REPLY in
        1)
            enssential_pkg
            ;;
        2)
            security_pkg
            ;;
        3)
            backup
            ;;
        4)
            restore_backup
            ;;
        99)
            echo "Arrêt du programme."
            break
            ;;
        *)
            echo "Option invalide, veuillez réessayer."
            ;;
    esac
done