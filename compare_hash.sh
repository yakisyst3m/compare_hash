#!/bin/bash
########################################################################################################
#                                                                                                      #
#                                  COMPARAISON HASH DE FICHIERS AVEC LISTE DE HASH                     #
#                                                                                                      #
#                                                                                                      #
########################################################################################################
# 
VERSION="V_1.0"
MAJ="2022/02/28"
AUTHOR="By_yakisyst3m"
#
###################################   NOTICE d'Uutilisation  ###########################################
#
# Lancer le script de cette façon :
# exemple : 
#			./compare_hash.sh <dossier_contenant_les_fichiers_à_scanner> <Fichier_contenant_la_liste_de_hash>
#
#   Le résultat de comparaison des hash se trouve dans :    /tmp/hash_resultats.txt
#
#####################################   LA CONFIGURATION  ##############################################

# Chemins d'accès des fichiers temporaires
DOSSIER_FICHIERS=$(dirname $1)
FICHIER_HASH=$2
CHEMIN_FICHIER_HASH="$(pwd)/$FICHIER_HASH"

# Compteur de fichiers supprimés
#COMPTEUR_FICHIERS=0


############################   FONCTIONS : TRAITEMENT DES FICHIERS   ##################################


function verifierFichier() 
{	
	FICHIER_A_SCANNER="$(pwd)/$i" # Chemin du fichier analysé
		
	if [[ -f "$FICHIER_A_SCANNER" ]] && [[ $FICHIER_A_SCANNER != "$CHEMIN_FICHIER_HASH" ]] # Si le fichier existe et n'est pas le fichier contenant la liste de hash
	then
		HASH=$(md5sum $FICHIER_A_SCANNER | cut -d " " -f1) # Faire le Hash du fichier
		
		if [[ "$HASH" == "$(grep $HASH $CHEMIN_FICHIER_HASH | cut -d " " -f1)" ]] # Si le hash existe dans le fichier qui liste les hash
		then 
			echo "Le hash $HASH $FICHIER_A_SCANNER: [OK vérifié]" | tee -a /tmp/hash_resultats.txt # Alors marquer le fichier de résultat par OK
			#((COMPTEUR_FICHIERS++))
		else
            echo "Le hash $HASH $FICHIER_A_SCANNER: [NOK il n'existe pas dans le fichier qui liste les hash]"  | tee -a /tmp/hash_resultats.txt # Sinon marquer le résultat par NOK
		fi
	
	fi
}

#####################################   DEBUT DU PROGRAMME  ##########################################

# On appelle un argument après l'appelle du script, celui-ci représente le dossier de recherche
cd $1

##### On remplace tous les espaces des noms de fichiers par des underscore pour éviter les problèmes de lectures
find ./ -name "* *" -type f -exec rename -v 's/\ /_/g' {} \;

# Parcourir les fichiers du répertoire 1 à 1
ListeFichiersEtDossiers=$(ls)

echo "$(pwd)/$FICHIER_HASH"

for i in $ListeFichiersEtDossiers
do
	verifierFichier $i
	echo "$i"
done 


#############################  RESULTATS DANS TERMLINAL ########################################

echo -e "o=======================================================================================o"
echo -e "|\t\t\t\t |\   /| 						|"
echo -e "|\t\t\t\t  \|_|/  						|"
echo -e "|\t\t\t\t  /. .\ 						|"
echo -e "|\t\t\t\t =\_Y_/= 						|"
echo -e "|\t\t\t\t  {>o<}  				---------------------------------\n|"
echo -e  "o========================     VOS RESULTATS   =========================	$MAJ $VERSION $AUTHOR\n|"

