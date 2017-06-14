#!/usr/bin/env bash
#
# Some command line of chapter 7 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

interactive=1

# Function in one-line
featurename(){ sed -e 's/,/\n/g;q';}
#             ^                   ^
#           SPACE              MANDATORY
#--------------------------------------------------
echo ''
echo ''
pushd book/ch07 > /dev/null
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Checking directories and files for chapter 7'
pushd book/ch07 > /dev/null
ls
ls data
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Header or not'
pushd book/ch07 > /dev/null
for i in data/*.csv;do
    echo $i
    head $i | awk -F',' '{print $1","$2}' | csvlook
done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Inspect all the data'
pushd book/ch07 > /dev/null
if [ interactif == 1 ];then
    echo 'tips.csv'
    less -S data/tips.csv
    echo 'investments2.csv'
    less -S data/investments2.csv
    echo 'tips.csv with csvlook'
    < data/tips.csv csvlook | less -S
    echo 'investments2.csv with csvlook'
    < data/investments2.csv csvlook | less -S
    popd > /dev/null
fi
#--------------------------------------------------
echo ''
echo 'Check feature name'
pushd book/ch07 > /dev/null
<data/iris.csv sed -e 's/,/\n/g;q'
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Check feature name using featurename function'
pushd book/ch07 > /dev/null
for i in data/*.csv;do
    echo $i
    <$i featurename
done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Check variable type'
pushd book/ch07 > /dev/null
<data/datatypes.csv csvlook
for i in data/*.csv;do
    echo $i
    csvsql $i
done
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Unique identifiers and factors'
pushd book/ch07 > /dev/null
cat data/iris.csv | csvcut -c species | body "sort | uniq | wc -l"
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'If the number of unique values is low compared to the number of rows -> categorical'
pushd book/ch07 > /dev/null
csvstat data/investments2.csv --unique
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Descriptive statitics'
pushd book/ch07 > /dev/null
csvstat data/datatypes.csv
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Descriptive statitics, check null'
pushd book/ch07 > /dev/null
csvstat data/datatypes.csv --null
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Descriptive statitics, subset of feature'
pushd book/ch07 > /dev/null
csvstat data/investments2.csv -c 2,13,19,24
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'extra check number of valid row'
pushd book/ch07 > /dev/null
echo '                                with tail'
csvstat data/iris.csv | tail -n 1
echo '                                with sed'
csvstat data/iris.csv | sed -rne '${s/^([^:]+): ([0-9]+)$/\2/;p}'
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Using R basic is a cumbersome'
pushd book/ch07 > /dev/null
cat > tmp.R <<EOF
tips <- read.csv('data/tips.csv',header=T,sep=',',stringsAsFactors=F)
tips.percent <- tips\$tip / tips\$bill * 100
cat(tips.percent,sep='\n',file='data/percent.csv')
q("no")
EOF
<tmp.R R --no-save
cat data/percent.csv
echo ''
echo "Avergage `csvstat data/percent.csv --mean`% "
echo ''
csvstat data/percent.csv
rm -f tmp.R
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Using Rio'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -b -e 'df$tip/df$bill*100' | head
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Using Rio'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -b -e 'df$percent <- df$tip / df$bill * 100;df' | head
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Rio statistics'
pushd book/ch07 > /dev/null
echo "mean"
<data/iris.csv Rio -e 'mean(df$sepal_length)'
echo""
echo "sd"
<data/iris.csv Rio -e 'sd(df$sepal_length)'
echo""
echo "sum"
<data/iris.csv Rio -e 'sum(df$sepal_length)'
echo""
echo "summary"
<data/iris.csv Rio -e 'summary(df$sepal_length)'
echo "skewness"
<data/iris.csv Rio -e 'library(moments);skewness(df$sepal_length)'
oecho ""
echo "kurtosis"
<data/iris.csv Rio -e 'library(moments);kurtosis(df$sepal_length)'
echo""
echo "corelation between two features"
<data/tips.csv Rio -e 'library(moments);cor(df$bill,df$tip)'
echo""
echo "corelation matrix"
<data/tips.csv csvcut -c bill,tip,tip | Rio -f cor | csvlook
echo""
echo "stem and leaf plot"
<data/iris.csv Rio -e 'stem(df$sepal_length)'
<data/iris.csv csvcut -c sepal_length | csvlook
echo""
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Gnuplot script'
pushd book/ch07 > /dev/null
ls data/immigration.dat
cat > tmp.gnu <<EOF
#!/usr/bin/gnuplot
set terminal pngcairo transparent enhanced font "arial,10"
# fontscale 1.0 size
set output 'histograms.6.png'
set border 3 front linetype -1 linewidth 1.000
set boxwidth 0.75 absolute
set style fill solid 1.00 border lt -1
set grid nopolar
set grid noxtics nomxtics ytics nomytics noztics nomztics \
nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault linetype 0 linewidth 1.000, linetype 0 linewidth 1.000
set key outside right top vertical Left reverse noenhanced autotitles columnhead
set style histogram columnstacked title offset character 0,0,0
set datafile missing '-'
set style data histograms
set xtics ()
set ytics border in scale 0,0 mirror norotate offset character 0,0,0 autojust
set ztics border in scale 0,0 nomirror norotate offset character 0,0,0 autoju
set cbtics border in scale 0,0 mirror norotate offset character 0,0,0 autojus
set rtics axis in scale 0,0 nomirror norotate offset character 0,0,0 autojust
set title "Immigration from Northern Europe\n(columstaked histogram)"
set xlabel "country of origin"
set ylabel "immigration by decade"
set yrange [ 0.00000 : * ] noreverse nowriteback
i=23
plot 'data/immigration.dat' using 6 ti col,'' using 12 ti col, '' using 13 ti col
EOF
chmod +x tmp.gnu
./tmp.gnu
#convert histograms.6.png histograms.6.pdf
#xpdf histograms.6.pdf
#rm -f histograms.6.pdf 
popd > /dev/null
##--------------------------------------------------
#echo ''
#echo 'feedgnuplot'
#pushd book/ch07 > /dev/null
#i=1
#j=1
#while [ $j == 1 ]; do
#    echo $RANDOM
#    i=$(( i + 1 ))
#    if [ $i == 1000 ];then j=0; fi
#done | \
#    feedgnuplot --stream --terminal 'dumb 80,25' --line --xlen 10
#popd > /dev/null
#--------------------------------------------------
echo ''
echo 'converting data from for gnuplot for ggplot2'
pushd book/ch07 > /dev/null
head data/immigration.dat
<data/immigration.dat sed -re '/^#/d;s/\t/,/g;s/,-,/,0,/g;s/Region/Period/' | tee data/immigration.csv | head | cut -c1-80
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Immigration Rio histogram'
pushd book/ch07 > /dev/null
<data/immigration-long.csv Rio -ge 'g+geom_bar(aes(Country,Count,fill=Period),stat="identity")+scale_fill_brewer(palette="Set1")+labs(x="Country of origin",y="Immigration by decade",title="Immigration from Northern Europe\n(columstacked histogram)")' > ImmigrationRioHistogram.png
ls -l ImmigrationRioHistogram.png
# display ImmigrationRioHistogram.png
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Bill Rio histogram'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -ge 'g+geom_histogram(aes(bill))' > BillRioHistogram.png
ls -l BillRioHistogram.png
popd > /dev/null
#--------------------------------------------------
echo ''
echo ''
pushd book/ch07 > /dev/null
<data/immigration.csv csvcut -c Period,Denmark,Netherlands,Norway,Sweden | \
    Rio -re 'library(reshape2);melt(df,id="Period",variable.name="Country",value.name="Count")' | tee data/immigration-long.csv | head | csvlook
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Bill feedgnuplot histogram'
pushd book/ch07 > /dev/null
<data/tips.csv csvcut -c bill | feedgnuplot --terminal 'dumb 80,25' \
					    --histogram 0 \
					    --with boxes \
					    --ymin 0 \
					    --binwidth 1.5 \
					    --unset grid \
					    --exit
popd > /dev/null
#--------------------------------------------------
echo ''
echo ''
pushd book/ch07 > /dev/null
<data/tips.csv csvcut -c size | header -d | feedgnuplot --terminal 'dumb 80,25' \
					    --histogram 0 \
					    --with boxes \
					    --unset grid \
					    --exit
popd > /dev/null

#--------------------------------------------------
echo ''
echo 'bar plot using Rio'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -ge 'g+geom_bar(aes(factor(size)))' > TipsRioHisto.png
ls -l TipsRioHisto.png
# display TipsRioHisto.png
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'bar plot using Rio'
pushd book/ch07 > /dev/null
<data/iris.csv Rio -ge 'g+geom_bar(aes(factor(species)))' > SpeciesRioHisto.png
ls -l TipsRioHisto.png
#display SpeciesRioHisto.png
popd > /dev/null
#--------------------------------------------------
if [ 1 == 2 ];then
echo ''
echo 'bar plot using Rio'
pushd book/ch07 > /dev/null
<data/investments2.csv  Rio -ge 'g+geom_bar(aes(factor(company_category_list)))'  > CompagnyRioHisto.png
ls -l CompagnyRioHisto.png
display CompagnyRioHisto.png
popd > /dev/null
fi
#--------------------------------------------------
echo ''
echo 'density plot with Rio'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -ge 'g+geom_density(aes(tip / bill * 100,fill=sex),alpha=0.3)+xlab("percent")' > densityplot.png
if [ $interactive == 1 ];then
    display densityplot.png
fi
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'Using Rio for drawing box pot'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -ge 'g+geom_boxplot(aes(time,bill))' > /dev/null #| display
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'using Rio for scatter plot'
pushd book/ch07 > /dev/null
<data/tips.csv Rio -ge 'g+geom_point(aes(bill,tip,color=time))' > /dev/null # | displayo
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'using feedgnuplot for scatter plot'
pushd book/ch07 > /dev/null
<data/tips.csv csvcut -c bill,tip | \
    tr , ' ' | \
    header -d | \
    feedgnuplot --terminal 'dumb 80,25' --points \
		--domain --unset grid --exit --style pt 14
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'usning Rio for line graphs'
pushd book/ch07 > /dev/nullD
<data/immigration-long.csv Rio -ge 'g+geom_line(aes(x=Period,y=Count,group=Country,color=Country))+theme(axis.text.x=element_text(angle=-45,hjust=0))' > /dev/null # | display
popd > /dev/null
#--------------------------------------------------
echo ''
echo 'using gnuplot for plot line graph'
pushd book/ch07 > /dev/null
<data/immigration.csv csvcut -c Period,Denmark,Netherlands,Norway,Sweden |\
    header -d |\
    tr , ' '  |\
    feedgnuplot --terminal 'dumb 80,25' --lines \
		--autolegend --domain \
		--legend 0 "Denmark" \
		--legend 1 "Netherlands" \
		--legend 2 "Norway" \
		--legend 3 "Sweeden" \
		--xlabel "Period" \
		--unset grid --exit
popd > /dev/null
