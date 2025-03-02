#!/usr/bin/bash

# Fonction pour vérifier si un programme est installé
check_installation() {
    if type -p $1 &>/dev/null; then
        echo "$1 est installé !"
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
        apt upgrade || upgrade
    else
        echo "OK"
        exit 1
    fi
}

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root" 
   exit 1
fi

while true; do
    cat << EOF

         #######                      ######                
            #     ####   ####  #      #     #  ####  #    # 
            #    #    # #    # #      #     # #    #  #  #  
            #    #    # #    # #      ######  #    #   ##   
            #    #    # #    # #      #     # #    #   ##   
            #    #    # #    # #      #     # #    #  #  #  
            #     ####   ####  ###### ######   ####  #    # 

        ToolBox facilite l'installation de l'essentiel pour 
        Transformer votre distribution en serveur.
        Assurez-vous d'être en root avant d'exécuter le script

        1. Mettre en place les éléments essentiels (Docker, etc.)
        2. Mettre en place les éléments essentiels de sécurité
        3. Faire une backup du pc (a faire avant tout)
        99. Quit
EOF

    read -p "->" REPLY

    case $REPLY in
        1)
            if ! check_installation docker; then
                install_program docker
            fi
            ;;
        2)
            echo "Mise en place des éléments essentiels de sécurité"
            if ! check_installation ufw; then
                install_program ufw
            fi
            ;;
        99)
            echo "Arrêt du programme"
            break
            ;;
        *)
            echo "Option invalide, veuillez réessayer."
            ;;
    esac
done