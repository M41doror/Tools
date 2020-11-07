#!/bin/bash


add_users()
{
	ROOT_UID=0    
	if      [ "$UID" -ne "$ROOT_UID" ]; then
        	echo "****Vous avez besoin d'être ROOT vous executer le Script !****"
        	exit
	fi
	echo
	echo Identité Verifié tu es ROOT MOTHERFUCKER !
	echo 

	echo -e "\n#########################################\n"
	echo -e "Selection du mode !!!\n"
	echo -e "1. Ajout l'utilisateur manuellement\n
2.Lis l'utilisateur automatiquement depuis une liste\n"
	echo -e "###########################################"
	read add_opt
	case $add_opt in
		1)
		echo -e "Entrer le nom de l'utilisateur:"
		read usr_name
		echo -e "Entrer le nom du groupe"
		read usr_group
		groupadd $usr_group
       	useradd -g $usr_group -m $usr_name
    	        echo -e "Entrer le mot de passe de l'utilisateur $usr_name"
 	passwd $usr_name ;;
	2)
       echo
       echo "Dossier de travail actuel: `pwd`/users.txt"
       echo
       echo -e "Voulez vous utilisez le PATH actuel? Yes=1 & No=2"
       read yn
if [ $yn == 1 ]; then
                      Path=$($pwd)users.txt
else
       echo -n "SVP Entrez le bon chemin (e.g. /root/folder/filename.txt): "
       read Path
fi
if [ -e $Path ]; then           #Si le fichier de l'utilisateur est présent
Username=lucky
num=1
	while  [ $Username != "EOF" ]
		do
		Username=`grep "Username00$num" $Path | cut -f2 -d:` #Extract le username depuis le fichier
num=$(($num+1))
		Password=`grep "Password" $Path | cut -f2 -d:`       #Extract Password depuis le fichier
		Group=`grep "Group" $Path |cut -f2 -d:`              #Extract Group depuis le fichier 
		
		groupadd $Group		
		
		               #Ajouter des users au system et leur donner un password
           if [ $Username == "EOF" ]; then
                   clear
                   main
           fi
                #Adds user to the system
                useradd -g $Group -m $Username 
                #Add users password
                echo $Password | /usr/bin/passwd --stdin $Username #Le mot de passe du user sera assigné
	done
else  
	echo -e "\n#############################################"
	echo -e "\n###### Aucun fichier disponible!!!!#####"
	echo -e "\n#############################################"
fi;;
*) echo -e "Arrete de faire le teubéet choisie le bon numéro !!!"
esac
        
}
varify()
{
	echo -e "#################################"
	echo -e "SVP Selectionne le mode!!!\n"
	echo -e "1.Verifier tout les utilisateurs depuis le mode\n
2.Verifier tout les utilisateurs\n"
	echo -e "#################################"
	read varify_user
case $varify_user in
		1) cat /etc/passwd |grep bash;;
		2)
 	echo
        echo "Le chemin actuel est : `pwd`/users.txt"
        echo
        echo -e "Veux tu utiliser le chemin actuel ? Yes=1 & No=2"
        read yn
if [ $yn == 1 ]; then
                     Path=$($pwd)users.txt
else
        echo -n "SVP entrer le bon chemin pour trouver le fichier : (e.g. /root/folder/filename.txt): "
        read Path
fi
if [ -e $Path ]; then
	Path=$($pwd)users.txt
	varify=`grep "Existe" $Path |cut -f2 -d:`
	  cat  /etc/passwd | grep $varify
  echo -e "\Il existe déja "
          cat /etc/passwd | grep $varify |wc -l
	  echo  "Utilisateur ajouté depuis le fichier TXT" 
else  
      echo -e "\n#############################################"
      echo -e "\n###### IMPOSSIBLE DE TROUVER LE FICHIER !!!!#####"
      echo -e "\n#############################################"
fi ;;
*) echo -e "Mauvais choix"
esac
					 
}

del_users()
{

ROOT_UID=0     
	if      [ "$UID" -ne "$ROOT_UID" ]; then
        	echo "****You must be the root user to run this script!****"
        	exit
	fi
	echo
	echo Tu es ROOT MOTHERFUCKER !
	echo
	
	echo
	echo "Le chemin est : `pwd`/students.txt"
	echo
	

echo -e "####################################"
echo -e "\n SVP Selectionne le mode !!!\n
1.Efface l'utilisateur selectionné\n
2.Efface tout les utilisateurs dans la liste\n"
echo -e "####################################"
read del_opt
case $del_opt in
	1)
		echo -e "\n\nL'utilisateur a été ajouté au systeme\n"
		 cat  /etc/passwd |grep bash
		echo -e "\n\n Tape le nom de l'utilisateur que tu veux effacer :"
		read user_name
		userdel -r $user_name ;;
	2) 
       echo
       echo "Le chemin actuel est : `pwd`/users.txt"
       echo
       echo -e "Voulez vous utiliser le chemin actuel ? Yes=1 & No=2"
       read yn
if [ $yn == 1 ]; then
       Path=$($pwd)users.txt
else
       echo -n "SVP Séléctionnez le bon chemin pour trouver le fichier(e.g. /root/folder/filename.txt): "
       read Path
fi
if [ -e $Path ]; then 		
		num=1
Username=lucky		
		while  [ $Username != "EOF" ]
		do
		Username=`grep "Username00$num" $Path | cut -f2 -d:`   
	
		if [ $Username == "EOF" ]; then
	    		clear
			main
		fi
				                       
                userdel -r $Username
num=$(($num+1))
	done
else  
	echo -e "\n#############################################"
	echo -e "\n######IMPOSSIBLE DE TROUVER LE FICHIER!!!!#####"
	echo -e "\n#############################################"
fi ;;
*) echo -e "Mauvais Choix !" 
esac
}

main()
{
	opt=1
while [ $opt -le 4 ]
do
	clear
echo -e "			### MENU ###\n 
			1. Ajouter un utilisateur\n
			2. Varifier l'utilisateur\n
			3. Effacer l'Utilisateur\n
			4. Sortir\n"
read opt
case $opt in
	1) add_users ;;
	2) varify ;;
	3) del_users ;;
	4) exit 0 ;;
	*) echo -e "Mauvais Choix!!!"
esac
echo -e "\nVoulez vous recommencer Oui=1 & Non=4."
read opt
done
}
main
exit 0
