#!/bin/bash
#Add course script

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
##############################
#  What do you want to add:  #
#  1) UE                     #
#  2) Module                 #
#  3) CM                     #
#  4) TD                     #
#  5) TP                     #
##############################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]]; do
  echo "Must be a number between 1 and 5 !"
  read -n 1 -r -s menu_choice
done
until [[ ! $menu_choice =~ [^1-5] ]]; do
  echo "Must be a number between 1 and 5 !"
  read -n 1 -r -s menu_choice
done

#Add UE
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
  #Create UE
  read -p 'Name of the UE you want to create: ' ue
  until [[ ! -z "$ue" ]]; do
    echo "The name of the UE can't be empty !"
    read -p 'Name of the UE you want to create: ' ue
  done
  mkdir "School_Directory/$year/$semester/$ue"
  #Update semester.info
  echo "$year|$semester|$ue||||||||" >> "School_Directory/$year/$semester/$year-$semester.info"
fi

#Add Module
if [ $menu_choice -eq 2 ]
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
  #Create module
  read -p 'Name of the module you want to create: ' module
  until [[ ! -z "$module" ]]; do
    echo "The name of the module can't be empty !"
    read -p 'Name of the module you want to create: ' module
  done
  mkdir "School_Directory/$year/$semester/$ue/$module"
  mkdir "School_Directory/$year/$semester/$ue/$module/cm"
  mkdir "School_Directory/$year/$semester/$ue/$module/td"
  mkdir "School_Directory/$year/$semester/$ue/$module/tp"
  #Update semester.info
  echo "$year|$semester|$ue|$module|||||||" >> "School_Directory/$year/$semester/$year-$semester.info"
fi

#Add CM/TD/TP
if  (($menu_choice >= 3 && $menu_choice <=5))
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
  #Create CM
  if [ $menu_choice -eq 3 ]
  then
    number=$((1 + `ls School_Directory/$year/$semester/$ue/$module/cm | wc -l`))
    mkdir "School_Directory/$year/$semester/$ue/$module/cm/cm$number"
    #Update semester.info
    #line=`grep -n "$year|$semester|$ue|$module|" "$year-$semester.info" | awk -F  ":" '{print $1}'`
    sed -i "/^$year|$semester|$ue|$module|/{s/[^|]*/$number/7}" "School_Directory/$year/$semester/$year-$semester.info"
  fi
  #Create TD
  if [ $menu_choice -eq 4 ]
  then
    number=$((1 + `ls School_Directory/$year/$semester/$ue/$module/td | wc -l`))
    mkdir "School_Directory/$year/$semester/$ue/$module/td/td$number"
    #Update semester.info
    sed -i "/^$year|$semester|$ue|$module|/{s/[^|]*/$number/6}" "School_Directory/$year/$semester/$year-$semester.info"
  fi
  #Create TP
  if [ $menu_choice -eq 5 ]
  then
    number=$((1 + `ls School_Directory/$year/$semester/$ue/$module/tp | wc -l`))
    mkdir "School_Directory/$year/$semester/$ue/$module/tp/tp$number"
    #Update semester.info
    sed -i "/^$year|$semester|$ue|$module|/{s/[^|]*/$number/5}" "School_Directory/$year/$semester/$year-$semester.info"
  fi
fi
