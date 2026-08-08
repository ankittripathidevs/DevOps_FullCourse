#!/bin/bash

# This is for & while loops

# Example-1

for ((num=1; num<=5; num++))
do
	mkdir "demo$num"
done


# Example-2

for i in 1 2 3 4 5
do
    echo "Number: $i"
done


# Example-3

for i in {1..6}
do
    echo "Num: $i"
done


# Example-4
 

for name in neha sneha
do 
	sudo useradd -m "$name"
	echo "user $name created"
done


