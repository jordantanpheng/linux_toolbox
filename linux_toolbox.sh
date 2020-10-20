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
#Check user type
read -n 1 -r -s user_type
until [[ ! -z "$user_type" ]]; do
  echo "Must be a number between 1 and 3 !"
  read -n 1 -r -s user_type
done
until [[ ! $user_type =~ [^1-3] ]]; do
  echo "Must be a number between 1 and 3 !"
  read -n 1 -r -s user_type
done


#Administrator
if [ $user_type -eq 1 ]
then
  read -p 'Username: ' username
  until [[ ! -z "$username" ]]; do
    echo "Username cannot be empty !"
    read -p 'Username: ' username
  done
fi

#Student
if [ $user_type -eq 2 ]
then
  read -p 'Username: ' username
  until [[ ! -z "$username" ]]; do
    echo "Username cannot be empty !"
    read -p 'Username: ' username
  done
cat << EOF
########################
#  Choose an action :  #
#  1) Import semester  #
#  2) Create semester  #
########################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]]; do
  echo "Must be a number between 1 and 2 !"
  read -n 1 -r -s menu_choice
done
until [[ ! $menu_choice =~ [^1-2] ]]; do
  echo "Must be a number between 1 and 2 !"
  read -n 1 -r -s menu_choice
done
  #Import semester sheet
  if [ $menu_choice -eq 1 ]
  then
    read -p 'Absolute path: ' path
    if ! [ -f "$path" ]
    then
      echo "This file does not exist !"
      exit
    fi
    ./scripts/import_semester.sh $path
  fi
  #Create semester sheet
  if [ $menu_choice -eq 2 ]
  then
    ./scripts/create_semester.sh
  fi
fi

#Teacher
if [ $user_type -eq 3 ]
then
  read -p 'Username: ' username
  until [[ ! -z "$username" ]]; do
    echo "Username cannot be empty !"
    read -p 'Username: ' username
  done
fi
