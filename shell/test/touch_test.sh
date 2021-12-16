#!/bin/bash

i=1
while :
do 
    touch $i.txt
    echo "$i"
    i=$[i+1]
done
