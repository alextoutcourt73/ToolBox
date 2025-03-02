#!/usr/bin/bash

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

            1. Installer les enssentiels (docker etc)
            2. Installer les essentiels de sécurité
            3. Faire une backup du pc (a faire avant tout)
            99. Quit
EOF

    read -p "->" REPLY

    case $REPLY in
    1) 
        if type -p docker &>/dev/null; then
            echo "Docker est installé !"
            exit 1
        fi
        
        if ! type -p docker &>/dev/null; then
            echo "Docker n'est pas installé, souhaitez vous l'installé ?"
            read -p "[>]" int
            if (( int == "y" )); then
                apt install -y docker
                apt upgrade || upgrade
            fi
        fi;;

        #installation des essentiels de sécurité
    2) 
        echo "Installation des essentiels de sécurité"

        apt install ufw -y

        apt install fail2ban -y
        ;;
        
    99)
          echo "Arret du prgramme"
          break;
    esac
done