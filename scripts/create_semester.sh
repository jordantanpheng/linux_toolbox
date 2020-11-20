#!/bin/bash
#Create semester sheet script

read -p 'Year: ' year
until [[ ! -z "$year" ]]; do
  echo "Year cannot be empty !"
  read -p 'Year: ' year
done
until [[ ! "$year" =~ [^0-9]+$ ]]; do
  echo "Year must be a number !"
  read -p 'Year: ' year
done

if [ -d "School_Directory/$year" ]
then
  ls -A "School_Directory/$year"
fi
read -p 'Semester (1 or 2): ' semester
until [[ ! -z "$semester" ]]; do
  echo "Semester number cannot be empty !"
  read -p 'Semester (1 or 2): ' semester
done
until [[ ! $semester =~ [^1-2] ]]; do
  echo "Must be a number between 1 and 2 !"
  read -p 'Semester (1 or 2): ' semester
done

#Semester sheet Name
semester_sheet="$year-$semester.info"
semester_creation=true

#Check if the semester already exists
check="School_Directory/$year/$semester"
if [ -d "$check" ]
then
  echo "$check: This semester already exists !"
  exit
fi

until [ $semester_creation == false ]; do
  read -p 'Name of UE: ' ue
  until [[ ! -z "$ue" ]]; do
    echo "Name of UE cannot be empty !"
    read -p 'Name of UE: ' ue
  done

  read -p 'Name of module: ' module
  until [[ ! -z "$module" ]]; do
    echo "Name of module cannot be empty !"
    read -p 'Name of module: ' module
  done

  read -p 'Number of tp: ' tp
  until [[ ! -z "$tp" ]]; do
    echo "Number of tp cannot be empty !"
    read -p 'Number of tp: ' tp
  done
  until [[ ! "$tp" =~ [^0-9]+$ ]]; do
      echo "Number of tp must be a number !"
      read -p 'Number of tp: ' tp
  done

  read -p 'Number of td: ' td
  until [[ ! -z "$td" ]]; do
    echo "Number of td cannot be empty !"
    read -p 'Number of td: ' td
  done
  until [[ ! "$td" =~ [^0-9]+$ ]]; do
      echo "Number of td must be a number !"
      read -p 'Number of td: ' td
  done

  read -p 'Number of cm: ' cm
  until [[ ! -z "$cm" ]]; do
    echo "Number of cm cannot be empty !"
    read -p 'Number of cm: ' cm
  done
  until [[ ! "$cm" =~ [^0-9]+$ ]]; do
      echo "Number of cm must be a number !"
      read -p 'Number of cm: ' cm
  done

  read -p 'Coefficient of module: ' coefficient
  until [[ ! -z "$coefficient" ]]; do
    echo "Coefficient of module cannot be empty !"
    read -p 'Coefficient of module: ' coefficient
  done
  until [[ ! "$coefficient" =~ [^0-9]+$ ]]; do
      echo "Coefficient must be a number !"
      read -p 'Coefficient of module: ' coefficient
  done

  read -p 'Teachers username:mail (separated by a comma) :' teachers
  read -p 'Coefficient of tp (<1): ' coefficient_tp
  read -p 'Coefficient of td (<1): ' coefficient_td
  read -p 'Coefficient of cm (<1): ' coefficient_cm
  echo -e "$year|$semester|$ue|$module|$tp|$td|$cm|$coefficient|$teachers|tp:$coefficient_tp,td:$coefficient_td,cm:$coefficient_cm|" >> $semester_sheet
  read -p "Do you want to create another ue/module ? (y/n)" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    semester_creation=false
  fi
done
./scripts/import_semester.sh $semester_sheet $1 && mv $name School_Directory/$year/$semester/$semester_sheet
