#!/bin/bash

set -e 
PEM=$HOME/.ssh/music1.pem
REMOTE=ubuntu@musicwon.com
# scp -r builds/web musicwon.com: 
bundle exec yeah build 
rsync -e "ssh -i $PEM" -a builds/web $REMOTE:
ssh $REMOTE <<-TEXTTEXT
  sudo cp -rf web/* /var/www/
TEXTTEXT
