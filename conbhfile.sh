#!/bin/bash
echo welcome govt site
echo enter yur age
read age
if [[ $age =~ ^[0-9]+$ ]]; then
if [ $age -gt 18 ]; then
	echo "ur eli"
else
	echo "ur not"
fi
else
	echo "Enter only valaid number"
fi
