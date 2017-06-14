#!/usr/bin/env bash
#
# Some command line of chapter 3 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

curlicue-setup \
    'https://api.twitter.com/oauth/request_token' \
    'https://api.twitter.com/oauth/authorize?oauth_token=$oauth_token' \
    'https://api.twitter.com/oauth/access_token' \
    credentials
curlicue -f credentials 'https://api.twitter.com/1/statuses/home_timeline.xml'

#
pushd ./book/ch03
ls data/imdb-250.xlsx
in2csv data/imdb-250.xlsx > data/imdb-250.csv
tail data/imdb-250.csv
in2csv data/imdb-250.xlsx | head | cut -c1-80
in2csv data/imdb-250.xlsx | head | csvcut -c Title,Year,Rating | csvlook
sql2csv --db 'sqlite:///data/iris.db' --query 'SELECT * FROM iris WHERE sepal_length > 7.5'
curl -s http://www.gutenberg.org/cache/epub/76/pg76.txt | head -n 10
curl http://www.gutenberg.org/cache/epub/76/pg76.txt | head -n 10
curl http://www.gutenberg.org/cache/epub/76/pg76.txt > data/finn.txt
curl -L j.mp/locatbbar
curl -I j.mp/locatbbar
curl -s http://api.randomuser.me | jq '.'
popd
