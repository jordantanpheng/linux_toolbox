#!/bin/bash

#Select user type
cat << EOF
######################
# Select user type:  #
# 1) Administrator   #
# 2) Student/Teacher #
######################
EOF

#Ask user type
read -n 1 -r -s user_type
until [[ ! -z "$user_type" ]] && [[ ! $user_type =~ [^1-3] ]]; do
  echo "Must be a number between 1 and 3 !"
  read -n 1 -r -s user_type
done

#Ask username
read -p 'Username: ' username
until [[ ! -z "$username" ]]; do
  echo "Username cannot be empty !"
  read -p 'Username: ' username
done

#Menu choices
cat << EOF
########################
#  Choose an action :  #
#  1) Import semester  #
#  2) Create semester  #
#  3) Add course       #
#  4) Delete course    #
########################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-4] ]]; do
  echo "Must be a number between 1 and 4 !"
  read -n 1 -r -s menu_choice
done
#Import semester sheet
if [ $menu_choice -eq 1 ]
then
  read -p 'Path: ' path
  if ! [ -f "$path" ]
  then
    echo "This file does not exist !"
    exit
  fi
  ./scripts/import_semester.sh $path $username
fi
#Create semester sheet
if [ $menu_choice -eq 2 ]
then
  ./scripts/create_semester.sh $username
fi
#Add course
if [ $menu_choice -eq 3 ]
then
  ./scripts/add_course.sh $username
fi
#Delete course
if [ $menu_choice -eq 4 ]
then
  ./scripts/delete_course.sh $username
fi
