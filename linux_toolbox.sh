#!/bin/bash

#Ask user type
cat << EOF
######################
# Select user type:  #
# 1) Administrator   #
# 2) Student/Teacher #
######################
EOF
read -n 1 -r -s user_type
until [[ ! -z "$user_type" ]] && [[ ! $user_type =~ [^1-2] ]]; do
  echo "Must be a number between 1 and 2 !"
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
###########################################
#  Choose an action :                     #
#  1) Import semester                     #
#  2) Create semester                     #
#  3) Add course                          #
#  4) Delete course                       #
#  5) Add user/group to a course          #
#  6) Delete user/group from a course     #
#  7) Add a devoir                        #
#  8) Edit devoir progression             #
#  9) Grade a devoir                      #
#  10) Visualize my work progress/grades  #
#  11) Write down a question/remark       #
#  12) Visualize questions/remarks        #
###########################################
EOF
read menu_choice
until [[ ! -z "$menu_choice" ]] && [[ "$menu_choice" -ge 1 ]] && [[ "$menu_choice" -le 12 ]]; do
  echo "Must be a number between 1 and 12 !"
  read menu_choice
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
  ./scripts/delete_course.sh
#Add user to a course
elif [ $menu_choice -eq 5 ]
then
  ./scripts/add_user_to_course.sh
#Delete user from a course
elif [ $menu_choice -eq 6 ]
then
  ./scripts/remove_user_from_course.sh
#Add a devoir
elif [ $menu_choice -eq 7 ]
then
  ./scripts/add_devoir.sh $username
#Edit devoir progression
elif [ $menu_choice -eq 8 ]
then
  ./scripts/edit_devoir_progression.sh $username
#Grade devoir
elif [ $menu_choice -eq 9 ]
then
  ./scripts/grade_devoir.sh
#Visualize work progress/grade
elif [ $menu_choice -eq 10 ]
then
  ./scripts/visualize_work.sh $username
#Write down questions/remarks
elif [ $menu_choice -eq 11 ]
then
  ./scripts/write_down_qr.sh
#Visualize questions/remarks
elif [ $menu_choice -eq 12 ]
then
  ./scripts/visualize_qr.sh
fi
