# ToolBox - Installation des paquets essentiels pour un serveur

## Description
ToolBox est un script shell permettant d'installer rapidement les paquets essentiels sur un serveur Linux. Il est conçu pour simplifier la mise en place d'un environnement de base en installant automatiquement les outils et dépendances courants.

## Fonctionnalités
- Mise à jour des paquets
- Installation des outils de base (docker, docker-compose, etc.)
- Installation des services essentiels (fail2ban, UFW, etc.)
- Créer et envoyer un backup sur un serveur distant

## Prérequis
- Un serveur fonctionnant sous une distribution Linux (Debian, Ubuntu, CentOS, etc.)
- Accès root

## Installation
1. Télécharger le script :
   ```sh
   curl https://github.com/alextoutcourt73/ToolBox/blob/Realease/script.sh | bash
   ```

## Personnalisation
Le script peut être modifié pour ajouter ou supprimer des paquets en fonction de tes besoins. Ouvre simplement le fichier avec un éditeur de texte :
```sh
nano script.sh
```

## Avertissement
Ce script effectue des modifications sur le système. Assure-toi de bien comprendre les actions réalisées avant de l'exécuter.

## Licence
Ce projet est sous licence Apache2.0 - Voir le fichier LICENSE pour plus de détails.

