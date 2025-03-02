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

            1. Mettre en place les éléments essentiels (Docker, etc.)
            2. Mettre en place les éléments essentiels de sécurité
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
            echo "Docker n'est pas installé, souhaitez-vous l'installer ? [y/n]"
            read -p "[>]" int
            if (( int == "y" )); then
                apt install -y docker
                apt upgrade || upgrade
            else
                echo "OK"
                exit 1
            fi
        fi;;

    2) 
        echo "Mise en place des éléments essentiels de sécurité"

        apt install ufw -y

        apt install fail2ban -y
        ;;
        
    99)
          echo "Arret du prgramme"
          break;
    esac
done