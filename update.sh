#!/bin/bash
# Author: Vincent Hindriksen
# This script updates the files, so that Dockerfiles' build can do its work

# Reading all variables from info.txt
CURRENT_VERSION=`grep "Version: " info.txt | cut -d " " -f 2`
# Currently info.txt gets more variables, make sure all variables are read, so they can be written back
echo "Current version is: $CURRENT_VERSION"
AVAILABLE_VERSION=`curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest | grep browser_download_url | grep "browser_download_url" | cut -d '"' -f 4 | cut -d "/" -f8`

# Check on major version upgrade
# If true, then quit, because anything can go wrong. Read the documentation, make the changes in the script and good luck.
if [ ${CURRENT_VERSION:0:2} != ${AVAILABLE_VERSION:0:2} ]; then
  echo "ERROR! MAJOR VERSION UPGRADE. Cannot automatically upgrade."
  echo "Please check osTicket's documentation what to do. This may include updating this script"
  exit 1
fi

# check is upgrade is needed
if [ $CURRENT_VERSION != $AVAILABLE_VERSION ]; then
  echo "A new version $AVAILABLE_VERSION is available. Downloading now"
  wget https://github.com/osTicket/osTicket/releases/download/$AVAILABLE_VERSION/osTicket-$AVAILABLE_VERSION.zip
  mv -f osTicket-$AVAILABLE_VERSION.zip osTicket-latest.zip
  rm -r build
  mkdir build
  unzip osTicket-latest.zip "upload/*" -d "build/"
  rm osTicket-latest.zip
  mv build/upload/* build
  rm -r build/upload
  rm -r build/setup
  cp crontab build
  cp error.ini build
  cp ost-config.php build/include
  # Updating files successful (there is no checking done yet)? 
  # Write back all variables. After this the script will assume the current version isupdated to the latest.
  echo "Version: $AVAILABLE_VERSION" > info.txt
else
  echo "All up-to-date!"
fi
