#!/bin/bash
#Add devoir script

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

#Ask the name of the devoir
read -p 'Name of your devoir: ' devoir_name
until [[ ! -z "$devoir_name" ]]; do
  echo "Your devoir must have a name !"
  read -p 'Name of your devoir: ' devoir_name
done

#Ask the initial progression value
read -p 'Set your progression (Value from 0 to 100): ' devoir_progression
until [[ ! -z "$devoir_progression" ]] && [[ "$devoir_progression" -ge 0 ]] && [[ "$devoir_progression" -le 100 ]]; do
  echo "Please set a correct value ! (Value from 0 to 100)"
  read -p 'Set your progression (Value from 0 to 100): ' devoir_progression
done

#Create the devoir directory
devoir_name="Devoir_$1_$devoir_name"
mkdir "School_Directory/$year/$semester/$ue/$module/$course_folder/$course/$devoir_name"

#Update semester.info
old_devoir_field=`grep "$year|$semester|$ue|$module" "School_Directory/$year/$semester/$year-$semester.info" | cut -d '|' -f11`
#Escape old_devoir_field
old_devoir_field=${old_devoir_field////\\/}
new_devoir_field="$old_devoir_field$course\/$devoir_name:$devoir_progression:x,"
sed -i "/^$year|$semester|$ue|$module/{s/[^|]*/$new_devoir_field/11}" "School_Directory/$year/$semester/$year-$semester.info"
#Update semester.conf
echo -e "$ue/$module/$course_folder/$course/$devoir_name|u:$1|u:$1|u:$1" >> School_Directory/$year/$semester/$year-$semester.conf
