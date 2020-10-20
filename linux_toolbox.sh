#!/bin/bash

#Select user type
cat << EOF
#####################
# Select user type: #
# 1) Administrator  #
# 2) Student        #
# 3) Teacher        #
#####################
EOF
read -n 1 -r -s user_type

#Check user type
if [[ $user_type =~ [^1-3] ]]
then
  echo "Must be a number between 1 and 3"
  exit
fi

#Administrator
if [ $user_type -eq 1 ]
then
  read -p 'Username: ' username
fi

#Student
if [ $user_type -eq 2 ]
then
  read -p 'Username: ' username
cat << EOF
#############################
#  Choose an action :       #
#  1) Import semester sheet #
#  2) Create semester sheet #
#############################
EOF
  read -n 1 -r -s menu_choice
  #Import semester sheet
  if [ $menu_choice -eq 1 ]
  then
    read -p 'Path: ' path
  fi
  if ! [ -d "$path" ]
  then
    echo "This file does not exist !"
    exit
  fi
  ./scripts/import.sh $path
  #Create semester sheet
  if [ $menu_choice -eq 1 ]
  then
    read -p 'Name of file: ' semester_name
    read -p 'Year: ' semester_year
    read -p 'Semester 1 or 2: ' semester_number
    read -p 'Name of UE: ' semester_ue
    read -p 'Name of module: ' semester_module
    read -p 'Number of tp: ' semester_tp
    read -p 'Number of td: ' semester_td
    read -p 'Number of cm: ' semester_cm


    read -p "Do you want to create an archive from these files ? (y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
    fi


  fi
fi

#Teacher
if [ $user_type -eq 3 ]
then
  read -p 'Username: ' username
fi
