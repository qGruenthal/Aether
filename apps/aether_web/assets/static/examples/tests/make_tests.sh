#!/bin/bash

for i in `seq 1 15`
do
    name=`printf "%02d" $i`
    output=`base64 /dev/urandom | head -c 1000`
    echo $output > t$name.out
    echo $output > t$name.ref
done
