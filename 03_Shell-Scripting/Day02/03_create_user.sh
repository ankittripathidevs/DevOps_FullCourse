#!/bin/bash

read -p "Enter username : " username

echo "You Entered $username"

sudo useradd -m $username

echo "New User Added"
