#!/bin/bash
#Edit devoir script

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

#Get the list of devoirs
devoir_field=`grep "$year|$semester|$ue|$module" "School_Directory/$year/$semester/$year-$semester.info" | cut -d '|' -f11`
IFS=',' read -r -a devoir_array <<< "$devoir_field"
i=0

#Print the devoirs matching the username
for devoir in "${devoir_array[@]}"
do
  if [[ $devoir == *"Devoir_$1"* ]]
  then
    let "i++"
    echo "$i. $devoir"
  fi
done

#Ask the user which devoir's progression he wants to change
read -p 'Choose a devoir (input a number): ' devoir_choice
until [[ ! -z "$devoir_choice" ]] && [[ ! $devoir_choice =~ [^1-"$i"] ]]; do
  echo "Must be a number between 1 and $i !"
  read -p 'Choose a devoir (input a number): ' devoir_choice
done

#Split the devoir between its name and its progression value
IFS=':' read -r -a devoir_choice_array <<< "${devoir_array[$devoir_choice]}"
echo "You selected ${devoir_choice_array[0]}"
echo "Your progression is ${devoir_choice_array[1]}%"

#Ask the user for the new progression value
read -p 'Set a new progression (Value from 0 to 100): ' new_devoir_progression
until [[ ! -z "$new_devoir_progression" ]] && [[ "$new_devoir_progression" -ge 0 ]] && [[ "$new_devoir_progression" -le 100 ]]; do
  echo "Please set a correct value ! (Value from 0 to 100)"
  read -p 'Set a new progression (Value from 0 to 100): ' new_devoir_progression
done

#Get line number to modify
line="$(grep -n "$year|$semester|$ue|$module" "School_Directory/$year/$semester/$year-$semester.info" | head -n 1 | cut -d: -f1)"
#Escape devoir
devoir=${devoir////\\/}
#Escape new_devoir
new_devoir="${devoir_choice_array[0]}:$new_devoir_progression"
new_devoir=${new_devoir////\\/}
#Update semester.info
sed -i ""$line"s/$devoir/$new_devoir/" "School_Directory/$year/$semester/$year-$semester.info"
