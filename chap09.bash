#!/usr/bin/env bash
#
# Some command line of chapter 9 from the book
# Data Science at the Command Line, 2016 by J. Janssens
#
##

interactive=0
showbug=0
long=0
if [ 1 == 2 ];then
    #--------------------------------------------------
    echo ''
    echo ''
    pushd book/ch09 > /dev/null
    popd > /dev/null

    #--------------------------------------------------
    echo ' '
    pushd book/ch09 > /dev/null
    echo 'book/ch09'
    ls -la # Check what is going on in ch09
    echo 'book/ch09/data'
    ls -la data # Check what is going on in ch09/data
    popd > /dev/null
    #--------------------------------------------------
    echo ' '
    echo 'Check that parallel work correctly'
    pushd book/ch09 > /dev/null
    #parallel --nonall --slf instances hostname # Check that parallel work correctly
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Get a dataset from internet'
    pushd book/ch09 > /dev/null
    if [ ! -f wine-red.csv ] && [ ! -f wine-white.csv ];then
	echo "go parallel curl"
	#   parallel "curl -sL http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-{}.csv > wine-{}.csv" ::: red white # Get a dataset from internet
    fi
    ls wine-*.csv
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Look at data file'
    pushd book/ch09 > /dev/null
    echo 'raw output'
    head -n 5 wine-{red,white}.csv | fold # Look at the beginning of data files
    echo 'number of line'
    wc -l wine-{red,white}.csv # Count number of line in each file
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Cleaning the data'
    pushd book/ch09 > /dev/null
    for T in red white;do <wine-$T.csv tr '[A-Z]; ' '[a-z],_' | tr -d \" > wine-${T}-clean.csv;done # cleaning dataset
    ls wine-*.csv # check
    popd > /dev/null
    #--------------------------------------------------

    echo ''
    echo 'Combine two datasets'
    pushd book/ch09 > /dev/null
    HEADER="$(head -n 1 wine-red-clean.csv),type" # building the new header
    csvstack -g red,white -n type wine-{red,white}-clean.csv | # combine two dataset
	csvcut -c $HEADER > wine-both-clean.csv # keep only wanted field
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Checkout if there is missing values'
    pushd book/ch09 > /dev/null
    csvstat wine-both-clean.csv --nulls # checkout if there is missing values
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Checkout statistics'
    pushd book/ch09 > /dev/null
    csvstat wine-both-clean.csv # checkout statistics
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'densityplot'
    pushd book/ch09 > /dev/null
    <wine-both-clean.csv Rio -ge 'g+geom_density(aes(quality,file=type), adjust=3, alpha=0.5)' > densityplot.png # densityplot between alcohol and quality
    if [ $interactive == 1 ];then
	display densityplot.png
    fi
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'linear link between alcohol and quality'
    pushd book/ch09 > /dev/null
    <wine-both-clean.csv Rio -ge 'ggplot(df,aes(x=alcohol,y=quality,color=type))+geom_point(position="jitter",alpha=0.2)+geom_smooth(method="lm")' > linear.png # density plot quality
    if [ $interactive == 1 ];then
	display linear.png
    fi
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    pushd book/ch09 > /dev/null
    echo 'scalling features (there is a problem here with cols)'
    if [ $showbug == 1 ];then
	<wine-both-clean.csv cols -C type Rio -f scale > wine-both-scaled.csv # scalling > wine-type.csv
    else
	<wine-both-clean.csv csvcut -C type | Rio -f scale | tr -d '"' > wine-both-2on2.csv
	<wine-both-clean.csv csvcut -c type > wine-both-1on2.csv 
	paste -d, wine-both-{2,1}on2.csv > wine-both-scaled.csv
	rm -f wine-both-1on2.csv wine-both-2on2.csv 
    fi
    wc -l wine-both-{clean,scaled}.csv
    csvstat wine-both-scaled.csv # statistics
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    pushd book/ch09 > /dev/null
    echo 'dimension reduction PCA'
    <wine-both-scaled.csv csvcut -C type,quality | sed '1d' | tapkee --method pca -o pca.csv # separate unlabled feature for tapkee
    <wine-both-scaled.csv csvcut -c type,quality | sed '1d' > type_quality.csv # labeled and target
    paste -d, pca.csv type_quality.csv | header -a x,y,type,quality | Rio-scatter x y type > pca.png # Scatter plot with Rio
    rm -f pca.csv type_quality.csv
    if [ $interactive == 1 ];then
	display pca.png
    fi
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    pushd book/ch09 > /dev/null
    echo 'dimension reduction T-SNE'
    <wine-both-scaled.csv csvcut -C type,quality | sed '1d' | tapkee --method t-sne -o t-sne.csv # separate unlabled feature for tapkee
    <wine-both-scaled.csv csvcut -c type,quality | sed '1d' > type_quality.csv # labeled and target
    paste -d, t-sne.csv type_quality.csv | header -a x,y,type,quality | Rio-scatter x y type > t-sne.png # Scatter plot with Rio
    rm -f t-sne.csv type_quality.csv
    if [ $interactive == 1 ];then
	display t-sne.png
    fi
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'First look at weka'
    pushd book/ch09 > /dev/null
    java -cp ~/app/weka-3-8-0/weka.jar weka.datagenerators.classifiers.regression.MexicanHat -n 10 | fold
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'weka wrapper'
    pushd book/ch09 > /dev/null
    export WEKAPATH=~/app/weka-3-8-0
    weka datagenerators.classifiers.regression.MexicanHat -n 10
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'usable weka class have help'
    pushd book/ch09 > /dev/null
    weka datagenerators.classifiers.regression.MexicanHat -h
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'not usable weka class do not have help'
    pushd book/ch09 > /dev/null
    weka filters.SimpleFilter -h
    popd > /dev/null
    #--------------------------------------------------
    if [ $long == 1 ];then
	echo ''
	echo 'find all weka class with help'
	pushd book/ch09 > /dev/null
	rm -rf weka
	mkdir weka
	rm -f weka.log
	unzip -l $WEKAPATH/weka.jar |
	    sed -rne 's/.*(weka)\/([^g])([^$]*)\.class$/\2\3/p' |
	    tr '/' '.' > weka.log
	<weka.log parallel --timeout 1 -j4 "export WEKAPATH=~/app/weka-3-8-0;weka {} -h >> ./weka/{}.log 2>&1"
	popd > /dev/null
    fi
    #--------------------------------------------------
    echo ''
    echo 'find all weka class with help'
    pushd book/ch09 > /dev/null
    grep -L 'Exception\|Error' ./weka/* > weka.classes
    wc -l weka.classes
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'find all weka class with help'
    pushd book/ch09 > /dev/null
    grep -L 'Exception\|Error' ./weka/* > weka.classes
    wc -l weka.classes
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'some class of interest on weka'
    pushd book/ch09 > /dev/null
    weka attributeSelection.PrincipalComponents
    weka classifiers.bayes.NaiveBayes
    weka classifiers.evaluation.ConfusionMatrix
    weka classifiers.functions.SimpleLinearRegression
    weka classifiers.meta.AdaBoostM1
    weka classifiers.trees.RandomForest
    weka clusterers.EM
    #weka filters.unsupervised.attribute.Normalize
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'clusterings EM'
    pushd book/ch09 > /dev/null
    if [ $showbug == 1 ];then
	< wine-both-scaled.csv csvcut -C quality,type |
	    weka-cluster clusterers.EM -N 5 |
	    csvcut -c cluster > data/wine-both-cluster-em.csv
    else
	<wine-both-scaled.csv csvcut -C quality,type  > /tmp/tmp.in
	weka core.converters.CSVLoader /tmp/tmp.in  |
	    weka filters.unsupervised.attribute.AddCluster -W "weka.clusterers.EM -N 5" > /tmp/tmp.clusters
	weka core.converters.CSVSaver -i /tmp/tmp.clusters | csvcut -c cluster > wine-both-cluster-em.csv
    fi
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'clusterings SimpleKMeans'
    pushd book/ch09 > /dev/null
    <wine-both-scaled.csv csvcut -C quality,type  > /tmp/tmp.in
    weka core.converters.CSVLoader /tmp/tmp.in  |
	weka filters.unsupervised.attribute.AddCluster -W "weka.clusterers.SimpleKMeans -N 5" > /tmp/tmp.clusters
    weka core.converters.CSVSaver -i /tmp/tmp.clusters | csvcut -c cluster > wine-both-cluster-kmean.csv
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'clusterings Cobweb'
    pushd book/ch09 > /dev/null
    <wine-both-scaled.csv csvcut -C quality,type  > /tmp/tmp.in
    weka core.converters.CSVLoader /tmp/tmp.in  |
	weka filters.unsupervised.attribute.AddCluster -W "weka.clusterers.Cobweb" > /tmp/tmp.clusters
    weka core.converters.CSVSaver -i /tmp/tmp.clusters | csvcut -c cluster > wine-both-cluster-cobweb.csv
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo ' Use T-SNE dimension reduction'
    pushd book/ch09 > /dev/null
    <wine-both-scaled.csv csvcut -C quality,type | body tapkee --method t-sne |
	header -r x,y > wine-both-xy.csv
    popd > /dev/null


    #--------------------------------------------------
    echo ''
    echo 'Parallel processing with Rio-scatter'
    pushd book/ch09 > /dev/null
    parallel -j1 "paste -d, wine-both-xy.csv wine-both-cluster-{}.csv | Rio-scatter x y cluster > clusters_{}.png" ::: em kmean cobweb
    if [ $interactive == 1 ];then
	display clusters_em.png &
	display clusters_kmean.png &
	display clusters_cobweb.png &
    fi
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Preprocessing datafiles'
    pushd book/ch09 > /dev/null
    if [ ! -d train ];then mkdir train;fi
    <wine-white-clean.csv nl -s, -w1 -v0 | sed 's/0,/id,/' > train/features.csv
    ls -la train/features.csv
    <train/features.csv head
    <train/features.csv tail
    popd > /dev/null


    #--------------------------------------------------
    if [ $long == 1 ];then
	echo ''
	echo 'Running regressions'
	pushd book/ch09 > /dev/null
	if [ ! -d outputskll ];then mkdir outputskll;fi
	run_experiment -l predict-quality.cfg
	popd > /dev/null
    fi

    #--------------------------------------------------
    echo ''
    echo 'Checkout out output files'
    pushd book/ch09 > /dev/null
    cd outputskll
    ls -l
    <Wine_summary.tsv head
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Get good pearson from summary file with SQL'
    pushd book/ch09 > /dev/null
    <outputskll/Wine_summary.tsv csvsql --query "SELECT learner_name, pearson FROM stdin WHERE fold = 'average' ORDER BY pearson DESC" | csvlook
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Jointure'
    pushd book/ch09 > /dev/null
    <train/features.csv head
    <outputskll/Wine_features.csv_LinearRegression.predictions tr '\t' ',' | head
    #csvjoin -c id train/features.csv <(<outputskll/Wine_features.csv_LinearRegression.predictions tr '\t' ',')
    parallel "csvjoin -c id train/features.csv <(< outputskll/Wine_features.csv_{}.predictions tr '\t' ',') | csvcut -c id,quality,prediction > {}" ::: RandomForestRegressor GradientBoostingRegressor LinearRegression
    csvstack *Regres* -n learner --filenames > predictions.csv
    #<predictions.csv csvlook | head
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Comparing outputskll of 3 regressions algo'
    pushd book/ch09 > /dev/null
    <predictions.csv Rio -ge 'g+geom_point(aes(quality, round(prediction), '\
     'color=learner), position="jitter", alpha=0.1) + facet_wrap(~ learner) + '\
     'theme(aspect.ratio=1) + xlim(3,9) + ylim(3,9) + guides(colour=FALSE) + '\
     'geom_smooth(aes(quality, prediction), method="lm", color="black") + '\
     'ylab("prediction")' | display
    popd > /dev/null
    #--------------------------------------------------
    echo ''
    echo 'Create a balanced dataset'
    pushd book/ch09 > /dev/null
    csvstack -n type -g red,white wine-red-clean.csv <(<wine-white-clean.csv body shuf | head -n 1600) |
	csvcut -c fixed_acidity,volatile_acidity,citric_acid,residual_sugar,chlorides,free_sulfur_dioxide,total_sulfur_dioxide,density,ph,sulphates,alcohol,type > wine-balanced.csv
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Checking that dataset is really balanced'
    pushd book/ch09 > /dev/null
    parallel --tag grep -c {} wine-balanced.csv ::: red white
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Split data between training and test'
    pushd book/ch09 > /dev/null
    < wine-balanced.csv header > wine-header.csv
    tail -n +2 wine-balanced.csv | shuf | split -d -n r/2
    parallel --xapply "cat wine-header.csv x0{1} > wine-{2}.csv" ::: 0 1 ::: train test
    parallel --tag grep -c {2} wine-{1}.csv ::: train test ::: red white
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Calling BigML'
    pushd book/ch09 > /dev/null
    bigmler --train wine-train.csv \
	    --test wine-test-blind.csv \
	    --prediction-info full \
	    --prediction-header \
	    --output-dir output \
	    --tag wine \
	    --remote
    popd > /dev/null

    #--------------------------------------------------
    echo ''
    echo 'Inspecting BigML result'
    pushd book/ch09 > /dev/null
    csvcut output/predictions.csv -c type | head
    popd > /dev/null
fi

#--------------------------------------------------
echo ''
echo 'Check results'
pushd book/ch09 > /dev/null
paste -d, <(csvcut -c type data/wine-test.csv) <(csvcut -c type output/predictions.csv) | awk -F, '{ if ($1 != $2) {sum+=1 } } END { print sum }'
popd > /dev/null

