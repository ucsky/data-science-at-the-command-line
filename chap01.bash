#!/usr/bin/env bash
#
# Some command line of chapter 1 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

chap=book/ch01;pushd $chap
if [ ! -d $chap/data2 ];then mkdir $chap/data2;fi
interactive=0

#--------------------------------------------------
whoami
#--------------------------------------------------
hostname
#--------------------------------------------------
date
#--------------------------------------------------
echo 'The command line is awesome!' | cowsay
#--------------------------------------------------
if [ -n "${NYTIMES_API_KEY}" ];then
    echo ''
    pushd data2
    parallel -j1 --progress --delay 0.1 --results results "curl -sL "\
 	     "'http://api.nytimes.com/svc/search/v2/articlesearch.json?q=New+York+'"\
 	     "'Fashion+Week&begin_date={1}0101&end_date={1}1231&page={2}&api-key='"\
     	     "'${NYTIMES_API_KEY}'" ::: {2009..2013} ::: {0..99} > /dev/null
    popd
else
    echo "Please setup NYTIMES_API_KEY"
fi
#--------------------------------------------------
tree data/results | head
#--------------------------------------------------
cat data/results/1/*/2/*/stdout |
    jq -c '
          .response.docs[] | 
          {date: .pub_date, type: .document_type,
          title: .headline.main }
          ' |
    json2csv -p -k date,type,title > data2/fashion.csv
#--------------------------------------------------
wc -l data2/fashion.csv
#--------------------------------------------------
< data2/fashion.csv cols -c date cut -dT -f1 | head | csvlook
#--------------------------------------------------
<data2/fashion.csv Rio -ge \
 'g + geom_freqpoly(aes(as.Date(date), color=type),binwidth=7)' \
 '+ scale_x_date() + labs(x="date", '\
 'title="Coverage of New York Fashion Week in New York Times")' > coverage.png
if [ $interactive == 1 ];then
    display coverage.png
fi
