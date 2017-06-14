#!/usr/bin/env bash
#
# Some command line of chapter 4 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

cd book/ch04
ls -l top-words-{1,2}.sh
cat data/finn.txt | ./top-words-4.sh
cat data/finn.txt | ./top-words-5.sh 30
echo $PATH | tr : '\n' | sort
echo "sh"
< data/76.txt ./top-words-5.sh 5
echo "Python"
< data/76.txt ./top-words.py 5
echo "R"
< data/76.txt ./top-words.R 5
echo 5 | ./stream.py
echo 5 | ./stream.R
cd ../../

exit
curl -s http://www.gutenberg.org/cache/epub/76/pg76.txt |
    tr '[:upper:]' '[:lower:]' |
    tr -d '[:digit:]' |
    tr -d '_' |
    grep -oE '\w+' |
    sort |
    uniq -c |
    sort -nr |
    head -n 10

