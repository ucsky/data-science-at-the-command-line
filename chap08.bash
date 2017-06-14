#!/usr/bin/env bash
#
# Some command line of chapter 8 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

instance=1
#--------------------------------------------------
echo ''
echo ''
pushd book/ch08 > /dev/null
popd > /dev/null
##--------------------------------------------------
echo ''
echo 'introduction to bc'
pushd book/ch08 > /dev/null
echo "4^2" | bc
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping over number (bash brace expension)'
pushd book/ch08 > /dev/null
for i in {0..10..2}
do
    echo "i=$i"
    echo "$i^2" | bc
done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping over lines generating a file'
pushd book/ch08 > /dev/null
if [ ! -f data/users2.json ];then
    curl -s "http://api.randomuser.me/?results=5" > data/users.json
fi
ls data/users.json
<data/users.json jq '.results[].user.email' | tr -d '\"' > data/emails.txt
cat data/emails.txt
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping over line with while'
pushd book/ch08 > /dev/null
while read line
do
    echo "Sending invitation to ${line}"
done <data/emails.txt
popd > /dev/null
#--------------------------------------------------
# echo ''
# echo 'reading stdin'
# pushd book/ch08 > /dev/null
# while read i;do echo "You typed $i.";done </dev/stdin
# popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping over files with globbing'
pushd book/ch07/data > /dev/null
for filename in *.csv;do echo "Processing ${filename}.";done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping over files with find'
pushd book/ch07 > /dev/null
find data -name '*.csv' -exec echo "Processing {}" \;
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'looping  over files in parallel'
pushd book/ch07 > /dev/null
find data -name '*.csv' -print0 | parallel -0 echo "Processing {}"
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'parallel processing'
pushd book/ch08 > /dev/null
chmod +x slow.sh
./slow.sh
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'slowing a process'
pushd book/ch08 > /dev/null
for i in {1..4};do
    (./slow.sh $i;echo Processed $i) &
done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'subshell not so good'
pushd book/ch08 > /dev/null
while read i;do
    (./slow.sh "$i";) &
done <data/movies.txt
popd > /dev/null
--------------------------------------------------
 echo ''
 echo 'introducing gnu parallel'
 pushd book/ch08 > /dev/null
 seq 5 | parallel "echo {}^2" | bc
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'Specifying changing input as an array'
 pushd book/ch08 > /dev/null
 <input.csv parallel -C, "echo {1} {2}"
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'Specifying input as CSV variables'
 pushd book/ch08 > /dev/null
 <input.csv parallel -C, --header : "echo {email} {name}"
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'Forcing no input argument'
 pushd book/ch08 > /dev/null
 seq 5 | parallel -N0 "echo The command line rules {}"
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'controlling the number of concurrent jobs'
 pushd book/ch08 > /dev/null
 echo "-j0"
 seq 5 | parallel -j0 "echo Hi {}"
 echo "-j200%"
 seq 5 | parallel -j200% "echo Hi {}"
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'logging and output (sperate file)'
 pushd book/ch08 > /dev/null
 seq 5 | parallel "echo \"Hi {}\" > data/hi-{}.txt"
 ls data/hi-*.txt
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'logging and output (all in one file)'
 pushd book/ch08 > /dev/null
 seq 5 | parallel "echo \"Hi {}\" > data/one-big-file.txt"
 ls data/one-big-file.txt
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'job order --keep-order or -k'
 pushd book/ch08 > /dev/null
 seq 8 | parallel -k "echo \"Hi {}\""
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'tag'
 pushd book/ch08 > /dev/null
 seq 8 | parallel --tag "echo \"Hi {}\""
 popd > /dev/null
 #--------------------------------------------------
 echo ''
 echo 'pbc'
 pushd book/ch08 > /dev/null
 seq 100 | pbc '{1}^2' |tail
 popd > /dev/null
--------------------------------------------------
echo ''
echo 'Distrbued computing'
pushd book/ch08 > /dev/null
 ssh-agent
 ssh-add
if [ $instance == 1 ];then
    parallel --nonall --slf instances hostname
else
    parallel --nonall --sshlogin : hostname
fi
popd > /dev/null
--------------------------------------------------
echo ''
echo 'number of cpu on remote host'
pushd book/ch08 > /dev/null
if [ $instance == 1 ];then
    seq 8 | parallel --slf instances "echo Hi {};hostname"
fi
popd > /dev/null

 #--------------------------------------------------
 echo ''
 echo 'distributing local data among remote machines'
 pushd book/ch08 > /dev/null
 seq 100 | parallel -N50 --pipe --slf instances "(hostname;wc -l) | paste -sd:"
 popd > /dev/null
 
 #--------------------------------------------------
 echo ''
 echo 'reduce the summation'
 pushd book/ch08 > /dev/null
 seq 100 | parallel -N50 --pipe --slf instances "paste -sd+ | bc" | paste -sd+ | bc
 popd > /dev/null
--------------------------------------------------
echo ''
echo 'pass a script'
pushd book/ch08 > /dev/null
seq 100 | parallel -N50 --basefile suml --pipe --slf instances "./suml" | ./suml
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'processing files on remote machines'
pushd book/ch08 > /dev/null
seq 0 100 100  | parallel "curl -sL 'http://data.cityofnewyork.us/resource/erm2-nwe9.json?\$limit=100&\$offset={}' | jq -c '.[]' | gzip > {#}.json.gz"
ls *.json.gz
popd > /dev/null
--------------------------------------------------
echo ''
echo 'json'
pushd book/ch08 > /dev/null
zcat 1.json.gz | head -n 1 | fold
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'json to CSV'
pushd book/ch08 > /dev/null
zcat 1.json.gz |
    jq -r '.borough' |
    tr '[A-Z] ' '[a-z]_' |
    sort | uniq -c |
    awk '{print $2","$1}' |
    header -a borough,count |
    csvsort -rc count |
    csvlook

popd > /dev/null
--------------------------------------------------
echo ''
echo 'json to CSV in parallel'
pushd book/ch08 > /dev/null
ls *.json.gz | parallel -v \
	 --trc {.}.csv \
	 --slf instances \
	 "zcat {} | jq -r '.borough' | tr '[A-Z] ' '[a-z]_' | sort | uniq -c | awk '{print \$2\",\"\$1}' > {.}.csv"
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'parallel clean up stuff on remote machine'
pushd book/ch08 > /dev/null
ssh $(head -n 1 instances) ls
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'parallel clean up stuff on remote machine'
pushd book/ch08 > /dev/null
cat 1.json.csv 
cat 2.json.csv 
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'agregate the various file with Rio'
pushd book/ch08 > /dev/null
cat *.json.csv |
    header -a borough,count |
    Rio -e 'aggregate(count ~ borough,df,sum)' |
    csvsort -rc count |
    csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'agregate the various file with csvsql'
pushd book/ch08 > /dev/null
cat *.json.csv |
    header -a borough,count |
    csvsql --query 'SELECT borough,
                    SUM(count) AS count 
                    FROM stdin 
                    GROUP BY borough 
                    ORDER BY count DESC' |
    csvlook
popd > /dev/null
