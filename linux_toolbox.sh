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
########################################
#  Choose an action :                  #
#  1) Import semester                  #
#  2) Create semester                  #
#  3) Add course                       #
#  4) Delete course                    #
#  5) Add user/group to a course       #
#  6) Delete user/group from a course  #
########################################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-6] ]]; do
  echo "Must be a number between 1 and 6 !"
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
#Create semester sheet
elif [ $menu_choice -eq 2 ]
then
  ./scripts/create_semester.sh $username
#Add course
elif [ $menu_choice -eq 3 ]
then
  ./scripts/add_course.sh $username
#Delete course
elif [ $menu_choice -eq 4 ]
then
  ./scripts/delete_course.sh $username
#Add user to a course
elif [ $menu_choice -eq 5 ]
then
  ./scripts/add_user_to_course.sh
#Delete user from a course
elif [ $menu_choice -eq 6 ]
then
  ./scripts/remove_user_from_course.sh
fi
