#!/bin/bash

# Day-02 of learning shell-scripting

<< comments
 # syntax #
function name() {
    # commands
}
name   // function calling
comments

# Example-1

# This is function defination 
function greet() {
  echo "Hello Ankit"
}
# function call here
greet

# Example-2

isLoyal() {
 read -p "Jetha ne mud ke kise dekha: " bandi
 read -p "Jetha ka pyaar %: " pyaar

 if [[ $bandi == "daya" ]]
 then
	echo "Jetha is Loyal"
 elif [[ $pyaar -ge 100 ]]
 then 
	echo "Jetha is Loyal"
 else
       	echo "Jetha is not Loyal"
 fi 
}
isLoyal


