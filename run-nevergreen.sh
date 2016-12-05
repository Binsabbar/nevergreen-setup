#!/bin/bash


function download_nevergreen() {
    echo $NEVERGREEN_VERSION > nevergreen.version
    wget $( curl -s https://api.github.com/repos/build-canaries/nevergreen/releases/latest | grep browser_download_url | head -n 1 | cut -d '"' -f 4 )
}

#check if there is a new release for never green
NEVERGREEN_VERSION=$(curl -s https://api.github.com/repos/build-canaries/nevergreen/releases/latest | grep "tag_name" | awk '{print $2}' | tr -d 'v,"')

#download the jar
if [ ! -f nevergreen-standalone.jar ]
then 
    echo "Downloading Nevergreen Jar"
    download_nevergreen
elif [ -f nevergreen.version ]; then
    LOCAL_VERSION=$(cat nevergreen.version)
    if [ "$LOCAL_VERSION" != "$NEVERGREEN_VERSION" ]
    then
        echo "Updating Nevergreen"
        rm -f nevergreen-standalone.jar
        download_nevergreen
    fi
fi

echo "Starting nevergreen"
PORT=$PORT java -jar nevergreen-standalone.jar
