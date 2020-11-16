#!/bin/bash
#Add user to course script

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

#Choose to give rights to a user or a group
cat << EOF
#######################################
#  Give rights to a user or a group:  #
#  1) User                            #
#  2) Group                           #
#######################################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-2] ]]; do
  echo "Must be a number between 1 and 2 !"
  read -n 1 -r -s menu_choice
done
if [ $menu_choice -eq 1 ]
then
  target="u"
elif [ $menu_choice -eq 2 ]
then
  target="g"
fi

#Ask the name of the user/group to give rights to
read -p 'Write the name of the user/group you want to give rights: ' user
until [[ ! -z "$user" ]]; do
  echo "The name of the user/group cannot be empty !"
  read -p 'Write the name of the user/group you want to give rights: ' user
done

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
#Select course folder (CM/TD/TP)
ls -A "School_Directory/$year/$semester/$ue/$module"
read -p 'Choose between a CM/TD/TP: ' course_folder
until [[ ! -z "$course_folder" ]] && [[ -d "School_Directory/$year/$semester/$ue/$module/$course_folder" ]]; do
  echo "This folder does not exists !"
  read -p 'Choose between a CM/TD/TP: ' course_folder
done
#Select course
if [ ! "$(ls -A "School_Directory/$year/$semester/$ue/$module/$course_folder")" ]
then
  echo "There is no course in this folder ! Create one before attributing rights."0
  exit
fi
ls -A "School_Directory/$year/$semester/$ue/$module/$course_folder"
read -p 'Write the name of the course: ' course
until [[ ! -z "$course" ]] && [[ -d "School_Directory/$year/$semester/$ue/$module/$course_folder/$course" ]]; do
  echo "This course does not exists !"
  read -p 'Write the name of the course: ' course
done

#Ask the user which rights to attribute
new_rights=true
#Menu choices
until [[ $new_rights == false ]]; do
cat << EOF
##############################
#  Rights you want to give:  #
#  1) Read                   #
#  2) Write                  #
#  3) Execute                #
##############################
EOF
  read -n 1 -r -s rights
  until [[ ! -z "$rights" ]] && [[ ! $rights =~ [^1-3] ]]; do
    echo "Must be a number between 1 and 3 !"
    read -n 1 -r -s rights
  done
  #Add read rights
  if [ $rights -eq 1 ]
  then
    old_rights=`grep "$ue/$module/$course_folder/$course" "School_Directory/$year/$semester/$year-$semester.conf" | cut -d '|' -f2`
    add_new_rights="$old_rights,$target:$user"
    sed -i "/^$ue\/$module\/$course_folder\/$course\//{s/[^|]*/$add_new_rights/2}" "School_Directory/$year/$semester/$year-$semester.conf"
  #Add write rights
  elif [ $rights -eq 2 ]
  then
    old_rights=`grep "$ue/$module/$course_folder/$course" "School_Directory/$year/$semester/$year-$semester.conf" | cut -d '|' -f3`
    add_new_rights="$old_rights,$target:$user"
    sed -i "/^$ue\/$module\/$course_folder\/$course\//{s/[^|]*/$add_new_rights/3}" "School_Directory/$year/$semester/$year-$semester.conf"
  #Add execute rights
  elif [ $rights -eq 3 ]
  then
    old_rights=`grep "$ue/$module/$course_folder/$course" "School_Directory/$year/$semester/$year-$semester.conf" | cut -d '|' -f4`
    add_new_rights="$old_rights,$target:$user"
    sed -i "/^$ue\/$module\/$course_folder\/$course\//{s/[^|]*/$add_new_rights/4}" "School_Directory/$year/$semester/$year-$semester.conf"
  fi
  read -p "Do you want to add other rights ? (y/n)" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    new_rights=false
  fi
done
