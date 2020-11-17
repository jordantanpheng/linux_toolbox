#!/bin/bash
#Visualize work progress/grades script

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

#Get the list of all devoirs from this semester
devoirs=`grep "$year|$semester|" "School_Directory/$year/$semester/$year-$semester.info" | cut -d '|' -f11`
#Trim all whitespaces
devoirs=`echo $devoirs | sed 's/ //g'`
IFS=',' read -r -a devoirs_array <<< "$devoirs"

#Ask user what he wants on the graph
cat << EOF
###########################################
# What do you want to see on the graph:   #
# 1) Work progress                        #
# 2) Grades                               #
# 3) Both at the same time                #
###########################################
EOF
read -n 1 -r -s menu_choice
until [[ ! -z "$menu_choice" ]] && [[ ! $menu_choice =~ [^1-3] ]]; do
  echo "Must be a number between 1 and 3 !"
  read -n 1 -r -s menu_choice
done

#Export all devoirs matching the username to a text file that will be used by gnuplot
for devoir in "${devoirs_array[@]}"
do
  if [[ $devoir == *"Devoir_$1"* ]]
  then
    IFS=':' read -r -a devoir_array <<< "$devoir"
    IFS='_' read -r -a devoir_name <<< "$devoir_array"
    if [ $menu_choice -eq 1 ]
    then
      echo "${devoir_name[2]} ${devoir_array[1]} 0" >> devoirs.txt
    elif [ $menu_choice -eq 2 ]
    then
      echo "${devoir_name[2]} ${devoir_array[2]} 0" >> devoirs.txt
    elif [ $menu_choice -eq 3 ]
    then
      echo "${devoir_name[2]} ${devoir_array[1]} ${devoir_array[2]}" >> devoirs.txt
    fi
  fi
done

#Export a config file that will be used by gnuplot
cat >> devoirs.conf << EOL
set terminal canvas
set output "devoirs.html"
set grid
set style data histograms
set style fill solid 1.00 border -1
EOL
if [ $menu_choice -eq 1 ]
then
  echo "plot 'devoirs.txt'  using 2:xtic(1) title 'Progress (%)', '' using 3 title ''" >> devoirs.conf
elif [ $menu_choice -eq 2 ]
then
  echo "plot 'devoirs.txt'  using 2:xtic(1) title 'Grade (/20)', '' using 3 title ''" >> devoirs.conf
elif [ $menu_choice -eq 3 ]
then
  echo "plot 'devoirs.txt'  using 2:xtic(1) title 'Progress (%)', '' using 3 title 'Grade (/20)'" >> devoirs.conf
fi

#Generate graph
cat devoirs.conf | gnuplot

#Open graph in web browser
firefox devoirs.html

#Delete files
rm devoirs.txt devoirs.conf devoirs.html
