#!/usr/bin/env bash
#
# Some command line of chapter 2 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

cd book/ch02/data/
head -n 3 movies.txt 
popd
fac(){(echo 1;seq $1) | paste -s -d\* | bc; }
fac 5
alias l='ls -1 --group-directories-first'
l
#
type -a pwd # example of shell builtin command
type -a cd
type -a fac
type -a l
echo -n "Hello" > hello-world
echo " World" >> hello-world
cat hello-world 
cat hello-world | wc -w
< hello-world  wc -w
mv hello-world book/ch02/data/
jq



