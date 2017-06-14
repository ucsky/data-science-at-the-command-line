#!/bin/bash -e
#
# Some command line of chapter 5 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

#--------------------------------------------------
echo ''
echo ''
pushd book/ch05 > /dev/null
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Filtering line'
pushd book/ch05 > /dev/null
echo "--"
seq -f "Line %g" 10 | tee lines
echo "--"
< lines head -n 3
echo "--"
< lines sed -n '1,3p'
echo "--"
< lines awk 'NR<=3'
echo "-- tail -n 3"
< lines tail -n 3
echo "-- tail -n +4"
< lines tail -n +4
echo "-- tail -n +5"
< lines tail -n +5
echo "-- sed '1,3d'"
< lines sed '1,3d'
echo "-- sed -n '1,3!p'"
< lines sed -n '1,3!p'
echo "-- head -n -3"
< lines head -n -3
echo "--"
< lines sed -n '4,6p'
echo "--"
< lines awk '(NR>=4)&&(NR<=6)'
echo "--"
< lines head -n 6 | tail -3
echo "--"
< lines sed -n '1~2p'
echo "--"
< lines awk 'NR%2'
echo "--"
< lines sed -n '0~2p'
echo "--"
< lines awk '(NR+1)%2'
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Filtering line based on pattern'
pushd book/ch05/data > /dev/null
grep -i chapter alice.txt
grep -E '^CHAPTER (.*)\. The' alice.txt
popd > /dev/null

#--------------------------------------------------
echo ''
echo 'Filtering line based on randomness'
seq 1000 | sample -r 1% | jq -c '{line: .}'
# echo ''
# seq 1000 | sample -r 1% -d 1000 -s 5
#--------------------------------------------------
echo ''
echo 'Extracting value'
pushd book/ch05/data > /dev/null
echo ''
grep -i chapter alice.txt | cut -d' ' -f3-
echo ''
sed -rn 's/^CHAPTER ([IVXLCDM]{1,})\. (.*)$/\2/p' alice.txt
echo ''
grep -i chapter alice.txt | cut -c 9-
echo ''
< alice.txt grep -oE '\w{3,5}' | head
echo ''
< alice.txt tr '[:upper:]' '[:lower:]' | grep -oE '\w{2,}' | grep -E '^a.*e$' | sort | uniq -c | sort -nr | awk '{print $2","$1}' | header -a word,count | head | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Remplacing and deleting value'
echo 'hello world!' | tr ' ' '_'
echo ''
echo 'hello world!' | tr -d -c '[a-z]'
echo ''
echo ' hello         world' | sed -re 's/hello/bye/;s/\s+/ /g;s/\s+//'

#--------------------------------------------------
echo ''
echo 'Working with CSV files'
echo "value\n7\n2\n5\n3" | body sort -n
echo ''
seq 5 | header -a count | body wc -l
echo ''
#seq 5 | header -a line | header -e "tr '[a-z]' '[A-Z]'"
echo ''
echo "Performing SQL queries on CSV"
seq 5 | header -a value | csvsql --query "SELECT SUM(value) AS sum FROM stdin"
echo "body command"



echo 'foo\nbar\nfoo' | sort | uniq -c | sort -nr
echo 'foo\nbar\nfoo' | sort | uniq -c | sort -nr |
    awk '{print $2","$1}' | header -a word,count
# Using sed on JSON data
pushd book/ch05 > /dev/null
sed -e 's/"gender":/"sex":/g' data/users.json | fold | head -n 3
popd > /dev/null
# Download html data
pushd book/ch05 > /dev/null
curl -sL https://en.wikipedia.org/wiki/List_of_countries_and_territories_by_border/area_ratio > wiki.html
popd > /dev/null
# Look at html data
pushd book/ch05 > /dev/null
head -n 10 wiki.html | cut -c1-79
popd > /dev/null
# Grep class wikitable after checkit out in Firefox dev
pushd book/ch05 > /dev/null
< wiki.html grep wikitable -A 21
popd > /dev/null
# Scraping
pushd book/ch05 > /dev/null
< wiki.html scrape -b -e 'table.wikitable > tr:not(:first-child)' > table.html
popd > /dev/null
# Print out scrapped table
pushd book/ch05 > /dev/null
head -n 21 table.html
popd > /dev/null
# XML/HTML -> JSON
pushd book/ch05 > /dev/null
< table.html xml2json > table.json
popd > /dev/null
# Look at JSON data
pushd book/ch05 > /dev/null
< table.json jq '.' | head -n 25
popd > /dev/null
# Working on JSON data
pushd book/ch05 > /dev/null
< table.json jq -c '.html.body.tr[] | {country: .td[1],border:.td[2][],surface: .td[3][]}' > countries.json
popd > /dev/null
# Printing some JSON data
pushd book/ch05 > /dev/null
head -n 10 countries.json
popd > /dev/null
# JSON -> CSV
pushd book/ch05 > /dev/null
< countries.json json2csv -p -k border,surface > countries.csv
popd > /dev/null
# Look at CSV data
pushd book/ch05 > /dev/null
head -n 11 countries.csv | csvlook
popd > /dev/null
# pipeline: Wikipedia -> CSV
pushd book/ch05 > /dev/null
curl -sL https://en.wikipedia.org/wiki/List_of_countries_and_territories_by_border/area_ratio \
     | scrape -b -e 'table.wikitable > tr:not(:first-child)' \
     | xml2json \
     | jq -c '.html.body.tr[] | {country: .td[1],border:.td[2][],surface: .td[3][]}' \
     | json2csv -p -k border,surface \
     | head -n 11 \
     | csvlook
popd > /dev/null
# Look at CSV file
pushd book/ch05 > /dev/null
< data/iris.csv head -n 5 \
    | csvlook
popd > /dev/null
# Extracting columns
pushd book/ch05 > /dev/null
< data/iris.csv csvcut -c sepal_length,petal_length,sepal_width,petal_width \
    | head -n 5 \
    | csvlook
popd > /dev/null
echo ''
echo 'Extracting columns using complements option -C '
pushd book/ch05 > /dev/null
< data/iris.csv csvcut -C species \
    | head -n 5 \
    | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Select only odd column'
echo -e 'a,b,c,d,e,f,g,h,i\n1,2,3,4,5,6,7,8,9' \
     | csvcut -c $(seq 1 2 9 | paste -sd,)
#--------------------------------------------------
echo ''
echo 'Cut not reorder things!'
echo -e 'a,b,c,d,e,f,g,h,i\n1,2,3,4,5,6,7,8,9' \
     | cut -d, -f 5,1,3
echo 'SQL reordering'
pushd book/ch05 > /dev/null
< data/iris.csv csvsql --query \
  "SELECT \
   sepal_length\
   ,petal_length\
   ,sepal_width\
   ,petal_width 
   FROM stdin" \
    | head -n 5 \
    | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Filtering line with sed'
seq 5 | sed -n '3,5p'
#--------------------------------------------------
echo ''
echo 'Filtering line using body command and sed'
seq 5 | header -a count | body sed -n '3,5p'
#--------------------------------------------------
echo ''
echo 'Filtering CSV using csvgreap'
pushd book/ch05 > /dev/null
csvgrep -c size -i -r "[1-4]" data/tips.csv | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Filtering CSV using AWK'
pushd book/ch05 > /dev/null
< data/tips.csv awk -F, '($1 > 40.0) && ($5 ~ /S/)' | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Filtering CSV using csvsql'
pushd book/ch05 > /dev/null
< data/tips.csv csvsql --query \
  "SELECT * FROM stdin \
   WHERE bill > 40 \
   AND day LIKE '%S%' \
  " \
  | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Look at table name.csv'
pushd book/ch05 > /dev/null
<data/names.csv csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Merging using sed'
pushd book/ch05 > /dev/null
<data/names.csv sed -re \
 '
  1s/.*/id,full_name,born/g;
  2,$s/(.*),(.*),(.*),(.*)/\1,\3 \2,\4/g
 ' \
 | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Merging with awk'
pushd book/ch05 > /dev/null
<data/names.csv awk -F, \
     '
     BEGIN{OFS=",";{print "id,full_name,born"}}
     {if(NR > 1){print $1,$3" "$2,$4}}
     ' \
    | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Merging using cols'
pushd book/ch05 > /dev/null
<data/names.csv cols -c first_name,last_name tr \", \" \" \" \
    | header -r full_name,id,born \
    | csvcut -c id,full_name,born \
    | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Merging with SQL'
pushd book/ch05 > /dev/null
<data/names.csv csvsql --query \
 "
 SELECT id,first_name || ' ' || last_name
 AS full_name,born FROM stdin 
" \
 | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed'
pushd book/ch05 > /dev/null
cat data/names-comma.csv
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed and merging using sed fail'
pushd book/ch05 > /dev/null
<data/names-comma.csv sed -re \
 '
  1s/.*/id,full_name,born/g;
  2,$s/(.*),(.*),(.*),(.*)/\1,\3 \2,\4/g
 ' \
 | tail -n 1
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed and merging with awk: fail'
pushd book/ch05 > /dev/null
<data/names-comma.csv awk -F, \
     '
     BEGIN{OFS=",";{print "id,full_name,born"}}
     {if(NR > 1){print $1,$3" "$2,$4}}
     ' \
    | tail -n 1
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed and merging using cols: fail'
pushd book/ch05 > /dev/null
<data/names-comma.csv cols -c first_name,last_name tr \", \" \" \" \
    | header -r full_name,id,born \
    | csvcut -c id,full_name,born \
    | tail -n 1
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed and merging with SQL: success!'
pushd book/ch05 > /dev/null
<data/names-comma.csv csvsql --query \
 "
 SELECT id,first_name || ' ' || last_name
 AS full_name,born FROM stdin 
" \
 | tail -n 1
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Last name composed and merging with Rio (R)'
pushd book/ch05 > /dev/null
<data/names-comma.csv Rio -e 'df$full_name<-paste(df$first_name,df$last_name);df[c("id","full_name","born")]' | tail -1
popd > /dev/null
echo 'Genrate multiple CSV files'
pushd book/ch05 > /dev/null
< data/iris.csv fieldsplit -d, -k -F species -p . -s .csh
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Checking that files have been splited'
pushd book/ch05/data > /dev/null
wc -l Iris-*.csv
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Concatenante vertically with cat'
pushd book/ch05 > /dev/null
cat data/Iris-setosa.csv \
    <(< data/Iris-versicolor.csv header -d) \
    <(< data/Iris-virginica.csv header -d) \
    | sed -n '1p;49,54p' \
    | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Concatenante vertically using cvsstack'
pushd book/ch05 > /dev/null
csvstack data/Iris-*.csv | sed -n '1p;49,54p' | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Concatenated vertically using cvsstack with filenames based field'
pushd book/ch05 > /dev/null
csvstack data/Iris-*.csv -n fspecies --filenames | cut -d, -f 1,2,3,4 | sed -n '1p;49,54p' | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Concatenated vertically using cvsstack with new field'
pushd book/ch05 > /dev/null
csvstack data/Iris-*.csv -n class -g a,b,c | cut -d, -f 1,2,3,4 | sed -n '1p;49,54p' | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Keep only bill and tip column'
pushd book/ch05 > /dev/null
<data/tips.csv csvcut -c bill,tip | tee bills.csv | head -n 3 | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Keep only day and time columns'
pushd book/ch05 > /dev/null
<data/tips.csv csvcut -c day,time | tee datetime.csv | head -n 3 | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Keep only sex, smoker and size columns'
pushd book/ch05 > /dev/null
<data/tips.csv csvcut -c sex,smoker,size | tee customers.csv | head -n 3 | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Horizontal concatenation'
pushd book/ch05 > /dev/null
paste -d, {bills,customers,datetime}.csv | head -n 3| csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Jointure with cvsjoint'
pushd book/ch05 > /dev/null
csvjoin -c species data/iris.csv data/irismeta.csv | csvcut -c sepal_length,sepal_width,species,usda_id | sed -n '1p;49,54p' | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Jointure with csvsql'
pushd book/ch05/data > /dev/null
csvsql --query "SELECT i.sepal_length, i.species, m.usda_id FROM iris i JOIN irismeta m ON (i.species=m.species)" iris.csv irismeta.csv \
    | sed -n '1p;49,54p' \
    | csvlook
popd > /dev/null
