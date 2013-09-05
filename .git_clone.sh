#!/bin/bash

dir=$(dirname "$(readlink -f $0)")
cd $dir
source .config.txt

REPOLIST=$(curl --silent "https://api.github.com/orgs/$ORGANISATION/repos?access_token=$ACCESS_TOKEN&per_page=100" | grep full_name | awk -F'"' '{print $4'})

for i in $REPOLIST
do
    dir=$(echo $i | sed "s/$ORGANISATION\///g");

    if [ ! -e "$dir.git" ]
    then
        git clone --mirror git@github.com:$i
    fi
done;
