#!/bin/bash

# Function with Arguments Type

# Example-1

greet() {
  echo "hello, $1"
}
greet "Ankit"
greet "Dhoni"


# Example-2

checkNumber() {
	if [[ $(( $1%2 )) -eq 0 ]]
	then 
		echo "$1 is Even"
	else
		echo "$1 is Odd"
	fi
}

checkNumber 100
checkNumber 11

# Example-3

isLoyal() {
 read -p "$1 ne mud ke kise dekha: " bandi
 read -p "$1 ka pyaar %: " pyaar

 if [[ $bandi == "daya" ]]
 then
	echo "$1 is Loyal"
 elif [[ $pyaar -ge 100 ]]
 then
	echo "$1 is Loyal"
 else
       	echo "$1 is not Loyal"
 fi
}

isLoyal "neha"

