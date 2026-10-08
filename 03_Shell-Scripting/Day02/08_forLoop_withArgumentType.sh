#!/bin/bash

# For loop with Argument Type

<< comments
$0 is agrument 0 which is file name 
$1 is argument 1 which is folder name 
$2 is argument 2 which is  start range 
$3 is argument 3 which is end range
comments

for (( num=$2; num<=$3; num++ ))
do
	mkdir "$1$num"
done
