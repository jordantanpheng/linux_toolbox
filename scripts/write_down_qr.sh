#!/bin/bash
#Write down question/remark script

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

#Ask user if he wants to write down a question or a remark
cat << EOF
########################################
# Select what you want to write down:  #
# 1) Question                          #
# 2) Remark                            #
########################################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-2] ]]; do
  echo "Must be a number between 1 and 2 !"
  read -n 1 -r -s menu_choice
done

#Ask user input for the question
if [ $menu_choice -eq 1 ]
then
  read -p 'Write down your question: ' question
  until [[ ! -z "$question" ]]; do
    echo "Question cannot be empty !"
    read -p 'Write down your question: ' question
  done
  echo $question >> "School_Directory/$year/$semester/$ue/$module/$course_folder/$course/questions.txt"
#Ask user input for the remark
elif [ $menu_choice -eq 2 ]
then
  read -p 'Write down your remark: ' remark
  until [[ ! -z "$remark" ]]; do
    echo "Remark cannot be empty !"
    read -p 'Write down your remark: ' remark
  done
  echo $remark >> "School_Directory/$year/$semester/$ue/$module/$course_folder/$course/remarks.txt"
fi
