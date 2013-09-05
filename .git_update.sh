#!/bin/bash

dir=$(dirname $(readlink -f $0))
cd $dir

if [ $# = 0 ] 
then
    DIRS=$(ls | grep '.git' | sed "s/\.git$//g")

    for DIR in $DIRS
    do  
        .git_update.sh $DIR
    done

else
    DIR=$1

    cd $DIR.git
    git remote update -p
    git update-server-info
    cd ..
fi
