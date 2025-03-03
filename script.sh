#!/usr/bin/bash

# Fonction pour vérifier si un programme est installé
check_installation() {
    if type -p $1 &>/dev/null; then
        echo "$1 est déjà installé."
        return 0
    else
        return 1
    fi
}

# Fonction pour installer un programme
install_program() {
    local program=$1
    echo "$program n'est pas installé, souhaitez-vous l'installer ? [y/n]"
    read -p "[>]" int
    if [[ $int == "y" ]]; then
        apt install -y $program
        apt update && apt upgrade
    else
        echo "Installation de $program annulée."
    fi
}

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root." 
   exit 1
fi

# Liste des programmes essentiels
essential_programs=("docker" "curl" "htop" "neofetch")

# Liste des programmes de sécurité
security_programs=("ufw" "fail2ban")

while true; do
    cat << EOF

         #######                      ######                
            #     ####   ####  #      #     #  ####  #    # 
            #    #    # #    # #      #     # #    #  #  #  
            #    #    # #    # #      ######  #    #   ##   
            #    #    # #    # #      #     # #    #   ##   
            #    #    # #    # #      #     # #    #  #  #  
            #     ####   ####  ###### ######   ####  #    # 

        ToolBox facilite l'installation de paquet essentiel pour 
        votre serveur.

        1. Télechargé les paquets essentiels 
        2. Téléchargé les paquets essentiels de sécurité
        3. Faire une backup du pc (work in progress)
        99. Quitter
EOF

    read -p "-> " REPLY

    case $REPLY in
        1)
            echo "Installation des éléments essentiels"
            for program in "${essential_programs[@]}"; do
                if ! check_installation $program; then
                    install_program $program
                fi
            done
            ;;
        2)
            echo "Mise en place des éléments essentiels de sécurité"
            for program in "${security_programs[@]}"; do
                if ! check_installation $program; then
                    install_program $program
                fi
            done
            ;;
        3)
            echo "Fonction de backup non implémentée."
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