#!/bin/bash
dir=$(dirname $(readlink -f $0))
cd $dir

source .config.txt

if [ ! -e .etags ]
then
    mkdir .etags
fi;

if [ ! -e .tmp ]
then
    mkdir .tmp 
fi;

if [ $# = 0 ] 
then
    DIRS=$(ls | grep '.git' | sed "s/\.git$//g")

    for DIR in $DIRS
    do  
        bash .git_check.sh $DIR
    done;

else 
    DIR=$1

    PREVIOUS_ETAG=$(cat .etags/$1.etag)

    curl -D .tmp/header -o .tmp/body --silent --header 'If-None-Match: "'$PREVIOUS_ETAG'"' "https://api.github.com/repos/$ORGANISATION/$1/events?access_token=$ACCESS_TOKEN&per_page=1"

    ETAG=$(cat .tmp/header | grep "ETag:" | awk -F'"' '{print $2}')

    if [ "$ETAG" = "" ]
    then
        # If empty given ETag we do nothing
        echo -n '';
    else
        # Save the last ETag for the next time
        echo $ETAG > .etags/$1.etag
        bash .git_update.sh $1
    fi  
fi
