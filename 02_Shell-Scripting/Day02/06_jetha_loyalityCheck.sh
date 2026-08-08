#!/bin/bash

<< disclaimer
This is only for fun purpose
disclaimer

read -p "Jetha ne mud ke kise dekha: " bandi
read -p "Jetha ka pyaar $ : " pyaar

if [[ $bandi == "daya bhabhi" ]];
then
       	echo "Jetha is Loyal"
elif [[ $pyaar -ge 100 ]];
then 
	echo "Jetha is Loyal"
else
	echo "Jetha is not Loyal"
fi
