#!/bin/bash

# Day-02 learning while loop

<< comments 
# Statement
while [[ condition ]]
do
    # commands
done
comments

# Example-1

count=1

while [[ $count -le 5 ]]
do
	echo "Number: $count"
	count=$((count+1))
done

# Example-2

num=20

while [[ $num -le 30 ]]
do
	if [[ $((num%2)) -eq 0  ]]
	then 
		echo "$num is Even"
	else
		echo "$num is Odd"
	fi

	num=$((num+1))
done


# Example-3

number=0

while [[ $number -le 10 ]]
do
	echo "$number"
	number=$((number+2))
done


