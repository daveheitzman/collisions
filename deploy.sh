#!/bin/bash

set -e 
REMOTE=musicwon.com
# scp -r builds/web musicwon.com: 
rsync -e "ssh -i $PEM" -a builds/web $REMOTE:
ssh $REMOTE <<-TEXTTEXT
  sudo cp -rf web/* /var/www/
TEXTTEXT
