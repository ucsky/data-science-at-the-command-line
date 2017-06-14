#!/usr/bin/env bash
#
# Some command line of chapter 6 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

# # Install Drake
# sudo apt-get install openjdk-6-jdk
# wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
# chmod +x lein
# git clone https://github.com/Factual/drake.git
# cd drake
# lein uberjar
# mv darke.jar ~/bin/
# git clone https://github.com/flatland/drip.git
# cd drip
# make prefix=~/bin install
# cd ~/bin
# cat > drake <<EOF
# #!/bin/bash
# drip -cp $(dirname $0)/drake.jar drake.core "$@"
# EOF
# chmod +x dake
# drake --version



#--------------------------------------------------
echo ''
echo ''
pushd book/ch06 > /dev/null
popd > /dev/null

#--------------------------------------------------
echo ''
echo 'obtain top ebooks from project gutenberg'
pushd book/ch06 > /dev/null
curl -s 'http://www.gutenberg.org/browse/scores/top' |
    grep -E '^<li>' |
    head -n 5 |
    sed -E "s/.*ebooks\/([0-9]+).*/\\1/" > data/top-5
cat data/top-5
popd > /dev/null



exit
