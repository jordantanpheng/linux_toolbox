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
read -n 1 -r -s
echo
case $REPLY in
  1)
    #Administrator
    user_type=1
    ;;
  2)
    #Student
    user_type=2
    ;;
  3)
    #Teacher
    user_type=3
    ;;
esac

#Administrator
if [ $user_type == 1 ]
then
  echo "Administrator"
fi

if [ $user_type == 2 ]
then
  echo "Student"
fi

if [ $user_type == 3 ]
then
  echo "Teacher"
fi

