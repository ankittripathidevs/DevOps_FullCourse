#!/bin/bash

echo "Username: $1"

sudo useradd -m "$1"

echo "New user added."
