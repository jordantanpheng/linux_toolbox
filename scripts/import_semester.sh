#!/bin/bash
#Import semester sheet script

#Check if the semester already exists
first_line=$(head -n 1 $1)
IFS='|' read -r -a arrFirstLine <<< "$first_line"
check="School_Directory/${arrFirstLine[0]}/${arrFirstLine[1]}"
if [ -d "$check" ]
then
  echo "$check: This semester already exists !"
  exit
fi

#Create School Directory if it doesnt exist
if [ ! -d "School_Directory" ]
then
    mkdir School_Directory
fi

#Create the folders according to the semester sheet
i=0
while IFS="" read -r p || [ -n "$p" ]
do
  IFS='|' read -r -a arrLine <<< "$p"
  #Create semester directory
  if [ $i -eq 0 ]
  then
    mkdir School_Directory/${arrLine[0]}
    mkdir School_Directory/${arrLine[0]}/${arrLine[1]}
    cp $1 School_Directory/${arrLine[0]}/${arrLine[1]}
  fi
  #Create UE if it doesn't exist
  if ! [ -d "School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}" ]
  then
    mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}
  fi
  #Create module
  mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}
  #Create tp directories
  mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/tp
  if [ ${arrLine[4]} -ne 0 ]
  then
    for j in $(eval echo "{1..${arrLine[4]}}")
    do
      mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/tp/tp$j
      echo -e "${arrLine[2]}/${arrLine[3]}/tp/tp$j/|u:$2|u:$2|u:$2" >> School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[0]}-${arrLine[1]}.conf
    done
  fi
  #Create td directory
  mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/td
  if [ ${arrLine[5]} -ne 0 ]
  then
    for j in $(eval echo "{1..${arrLine[5]}}")
    do
      mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/td/td$j
      echo -e "${arrLine[2]}/${arrLine[3]}/td/td$j/|u:$2|u:$2|u:$2" >> School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[0]}-${arrLine[1]}.conf
    done
  fi
  #Create cm directory
  mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/cm
  if [ ${arrLine[6]} -ne 0 ]
  then
    for j in $(eval echo "{1..${arrLine[6]}}")
    do
      mkdir School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[2]}/${arrLine[3]}/cm/cm$j
      echo -e "${arrLine[2]}/${arrLine[3]}/cm/cm$j/|u:$2|u:$2|u:$2" >> School_Directory/${arrLine[0]}/${arrLine[1]}/${arrLine[0]}-${arrLine[1]}.conf
    done
  fi
  let "i++"
done < $1
