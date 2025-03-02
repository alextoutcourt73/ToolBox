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

                ToolBox permet d'installer l'essentiel pour 
                transformer votre distribution en serveur.
                Veyez a bien etre en root avant déxécuté le script

            1. Installer les enssentiels (docker etc)
            2. Installer les essentiels de sécurité
            2. Faire une backup du pc (a faire avant tout)
            3. Quit
EOF

    read -p "->" reply

    case $REPLY in
        1)
        if type -p docker &>/dev/null; then
            echo "Docker est installé !"
            exit 1
        fi
        
        if ! type -p docker &>/dev/null; then
            echo "Docker n'est pas installé, souhaitez vous l'installé ?"
            read -p "[>]" int
            if (( $int == "y" )); then
                apt install docker
            fi
        fi;;

        1)

        ;;
        
        3)
          echo "Arret du prgramme"
          break;
    esac
done