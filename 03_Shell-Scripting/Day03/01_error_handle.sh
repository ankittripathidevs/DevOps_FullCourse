#!/bin/bash

# Day-03: Advance Scripting & Debugging Technique

<< notes
$?              → Check previous command status
if command      → Handle success/failure
&&              → Run if successful
||              → Run if failed
exit 0          → Success
exit 1          → Error
notes

# Example-1

create_directory() {
	mkdir demo
}

if ! create_directory
then 
	echo "Directory creation failed"
	exit 1
fi

echo "Directory created sucessfully"
