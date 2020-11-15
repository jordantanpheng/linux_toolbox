#!/bin/bash
#Delete course script

#Check if School_Directory exists
if [ ! -d "School_Directory" ]
then
    echo "School_Directory does not exist !"
    echo "Please import or create a semester and try again."
    exit
fi
#Check if at least one semester exists
if [ ! "$(ls -A "School_Directory")" ]
then
  echo "No semester found !"
  echo "Please import or create a semester and try again."
  exit
fi

#Menu choices
cat << EOF
#################################
#  What do you want to delete:  #
#  1) UE                        #
#  2) Module                    #
#  3) Last CM                   #
#  4) Last TD                   #
#  5) Last TP                   #
#################################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-5] ]]; do
  echo "Must be a number between 1 and 5 !"
  read -n 1 -r -s menu_choice
done

#Delete UE
if [ $menu_choice -eq 1 ]
then
  #Select year of the semester
  ls -A "School_Directory"
  read -p 'Write the year of the semester: ' year
  until [[ ! -z "$year" ]] && [[ -d "School_Directory/$year" ]]; do
    echo "This year does not exists !"
    read -p 'Write the year of the semester: ' year
  done
  #Select name of the semester
  ls -A "School_Directory/$year"
  read -p 'Write the name of the semester: ' semester
  until [[ ! -z "$semester" ]] && [[ -d "School_Directory/$year/$semester" ]]; do
    echo "This semester does not exists !"
    read -p 'Write the name of the semester: ' semester
  done
  #Select UE
  ls -A "School_Directory/$year/$semester"
  read -p 'Name of the UE you want to delete: ' ue
  until [[ ! -z "$ue" ]]; do
    echo "The name of the UE can't be empty !"
    read -p 'Name of the UE you want to delete: ' ue
  done
  rm -rf "School_Directory/$year/$semester/$ue"
  #Update semester.info
  sed -i "/$year|$semester|$ue|/d" "School_Directory/$year/$semester/$year-$semester.info"

#Delete module
elif [ $menu_choice -eq 2 ]
then
  #Select year of the semester
  ls -A "School_Directory"
  read -p 'Write the year of the semester: ' year
  until [[ ! -z "$year" ]] && [[ -d "School_Directory/$year" ]]; do
    echo "This year does not exists !"
    read -p 'Write the year of the semester: ' year
  done
  #Select name of the semester
  ls -A "School_Directory/$year"
  read -p 'Write the name of the semester: ' semester
  until [[ ! -z "$semester" ]] && [[ -d "School_Directory/$year/$semester" ]]; do
    echo "This semester does not exists !"
    read -p 'Write the name of the semester: ' semester
  done
  #Select UE
  ls -A "School_Directory/$year/$semester"
  read -p 'Write the name of the UE: ' ue
  until [[ ! -z "$ue" ]] && [[ -d "School_Directory/$year/$semester/$ue" ]]; do
    echo "This UE does not exists !"
    read -p 'Write the name of the UE: ' ue
  done
  #Delete module
  ls -A "School_Directory/$year/$semester/$ue"
  read -p 'Name of the module you want to delete: ' module
  until [[ ! -z "$module" ]]; do
    echo "The name of the module can't be empty !"
    read -p 'Name of the module you want to delete: ' module
  done
  rm -rf "School_Directory/$year/$semester/$ue/$module"
  #Update semester.info
  sed -i "/$year|$semester|$ue|$module|/d" "School_Directory/$year/$semester/$year-$semester.info"

#Delete CM/TD/TP
elif  (($menu_choice >= 3 && $menu_choice <=5))
then
  #Select year of the semester
  ls -A "School_Directory"
  read -p 'Write the year of the semester: ' year
  until [[ ! -z "$year" ]] && [[ -d "School_Directory/$year" ]]; do
    echo "This year does not exists !"
    read -p 'Write the year of the semester: ' year
  done
  #Select name of the semester
  ls -A "School_Directory/$year"
  read -p 'Write the name of the semester: ' semester
  until [[ ! -z "$semester" ]] && [[ -d "School_Directory/$year/$semester" ]]; do
    echo "This semester does not exists !"
    read -p 'Write the name of the semester: ' semester
  done
  #Select UE
  ls -A "School_Directory/$year/$semester"
  read -p 'Write the name of the UE: ' ue
  until [[ ! -z "$ue" ]] && [[ -d "School_Directory/$year/$semester/$ue" ]]; do
    echo "This UE does not exists !"
    read -p 'Write the name of the UE: ' ue
  done
  #Select module
  ls -A "School_Directory/$year/$semester/$ue"
  read -p 'Write the name of the module: ' module
  until [[ ! -z "$module" ]] && [[ -d "School_Directory/$year/$semester/$ue/$module" ]]; do
    echo "This module does not exists !"
    read -p 'Write the name of the module: ' module
  done
  #Delete CM
  if [ $menu_choice -eq 3 ]
  then
    number=`ls School_Directory/$year/$semester/$ue/$module/cm | wc -l`
    rm -rf "School_Directory/$year/$semester/$ue/$module/cm/cm$number"
    new_number=$(($number - 1))
    #Update semester.info
    sed -i "/^$year|$semester|$ue|$module|/{s/[^|]*/$new_number/7}" "School_Directory/$year/$semester/$year-$semester.info"
    #Update semester.conf
    sed -i "/$ue\/$module\/cm\/cm$number/d" "School_Directory/$year/$semester/$year-$semester.conf"
  #Delete TD
  elif [ $menu_choice -eq 4 ]
  then
    number=`ls School_Directory/$year/$semester/$ue/$module/td | wc -l`
    rm -rf "School_Directory/$year/$semester/$ue/$module/td/td$number"
    new_number=$(($number - 1))
    #Update semester.info
    sed -i "/$ue\/$module\/td\/td$number/d" "School_Directory/$year/$semester/$year-$semester.conf"
  #Delete TP
  elif [ $menu_choice -eq 5 ]
  then
    number=`ls School_Directory/$year/$semester/$ue/$module/tp | wc -l`
    rm -rf "School_Directory/$year/$semester/$ue/$module/tp/tp$number"
    new_number=$(($number - 1))
    #Update semester.info
    sed -i "/$ue\/$module\/tp\/tp$number/d" "School_Directory/$year/$semester/$year-$semester.conf"
  fi
fi
