#!/usr/bin/env bash
#
# Install some (not all)  dependencies needed for run example in the
# book Data Science at the Command Line, 2016 by J. Janssens
# with an Ubuntu distribution
#
##
sudo apt-get install cowsay
sudo apt-get install tree
# XML2JSON
sudo apt-get install nodejs-legacy
sudo apt-get install npm
npm install xml2json-command
# JSON2CSV
if [ -z "$GOPATH" ];then
    "Please setup GOPATH variable in your env and add GOPATH/bin to PATH"
    exit 1
fi
go get github.com/jehiah/json2csv
