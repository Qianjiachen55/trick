#!/bin/bash

i=1
while :
do 
    mkdir $i
    echo "$i"
    i=$[i+1]
done
