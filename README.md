nerdml
======

This project contains a list of scripts used to format the ouput of NER parsers such as 
NERD, Stanford-CRF and Ritter's UW_Twitter_NLP, as input of a machine learner algorithm.

3rd party libraries used in these scripts:
- Weka: http://www.cs.waikato.ac.nz/ml/weka/
- Stanford-CRF: http://nlp.stanford.edu/software/CRF-NER.shtml
- Ritter's UW_Twitter_NLP: https://github.com/aritter/twitter_nlp


#### Documentation
This documentation explains how to create machine learning datasets out of the NERD, Stanford and UW_Twitter_NLP outputs. 
The commands in this file assume that there are 10 folders named 1 to 10 that each contain one part of the dataset for 10-fold cross validation.
    
##### input
a CSV file (nerdANDstanfordANDuwtwitternlp.mconll), where the columns are: 
- 1st:       token
- 2nd:       GS
- 3rd..12th: NERD_i parser (alphabetic order)
- 13th:      Stanford-CRF
- 14th:      Ritter's UW_Twitter_NLP

##### preprocessing
Create input file for pos tagger (make sure the file has two columns, even if the second is only a dummy column, otherwise the tagger will choke):   

    cd cross_validation ;
    # the pos tagger assumes proper hashtags and urls, so insert some dummy values here
    for x in {1..10} ; \
      do cd $x ;\ 
      gcut -f1,2 -d" " < nerdANDstanfordANDuwtwitternlp.mconll | gsed 's/_Mention_/\@blabla/g ; s/_URL_/http:\/\/www.blabla.com/g ; s/_HASHTAG_/\#pgroth/g' | gtr " " "\t" > nerdANDstanfordANDuwtwitternlp_inputForPOS ; \
      cd .. ; \
    done
    # also put second part of the file somewhere 
    for x in {1..10} ; \ 
      do cd $x ;\
      gcut -f2- -d" " < nerdANDstanfordANDuwtwitternlp.mconll > nerdANDstanfordANDuwtwitternlp_complementToPOS ; \
      cd .. ; \
    done
    # run the pos tagger (check the location of the tagger!)
    for x in {1..10} ; \
      do cd $x ; ./../../../ark-tweet-nlp-0.3.2/runTagger.sh --input-format conll nerdANDstanfordANDuwtwitternlp_inputForPOS | gcut -f1,2 | gtr "\t" " " | gsed 's/@blabla/_Mention_/g ; s/http:\/\/www.blabla.com/_URL_/g ; \
      s/\#pgroth/_HASHTAG_/g' > nerdANDstanfordANDuwtwitternlp_postagged.conll ; \
      cd .. ; \
    done
    # glue the files together 
    for x in {1..10} ; \
      do cd $x ; \
      paste -d" " nerdANDstanfordANDuwtwitternlp_postagged.conll nerdANDstanfordANDuwtwitternlp_complementToPOS > nerdANDstanfordANDuwtwitternlp_POStaggedInputForPostProcessingRules.mcoll ; \
      cd .. ; \
    done 


Add naive gazetters. Run rules (_URL_ can't be an entity etc )Check the location of the RunNERDPostprocessingRules.pl script and adjust the path if necessary:  

    for x in {1..10} ; \
      do cd $x ; \
      perl Scripts/RunNERDPostprocessingRules.pl nerdANDstanfordANDuwtwitternlp_POStaggedInputForPostProcessingRules.mcoll > nerdANDstanfordANDuwtwitternlp_POStaggedPostProcessedInputForMLFeatureGeneration.mcoll ; \
      cd .. ; \
    done
    

Align with GS to reinsert _ENDOFTWEET_ tokens (needed for some ML features):

    for x in {1..10} ; \
      do cd $x ; \
      perl Scripts/alignGoldStandardWithNERDOutput.pl validation.GS nerdANDstanfordANDuwtwitternlp_POStaggedPostProcessedInputForMLFeatureGeneration.mcoll | cut -f3 | sed 's/\%/percent/g'  > nerdANDstanfordANDuwtwitternlp_POStaggedPostProcessedInputForMLFeatureGeneration_aligned.mcoll ; \
      cd .. ; \
    done  


Add ML features:

    for x in {1..10} ; \
      do cd $x ; \
      perl Scripts/AddMLFeaturesAndCLeanUp.pl nerdANDstanfordANDuwtwitternlp_POStaggedPostProcessedInputForMLFeatureGeneration_aligned.mcoll > ../../MachineLearningExperiments/nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part$x.mcoll ; 
      cd .. ; \
    done 

##### data formatting

Weka is slightly pickier than some other machine learning packages regarding its input, so here are a few more commands in order to convert the space separated feature vectors to Weka's ARFF format. 

    cd to/path/of/MachineLearningExperiments
    for x in *mcoll ; \
      do echo "token,pos,initcap,allcaps,prefix,suffix,capitalisationfrequency,start,end,alchemy,spotlight,extractiv,lupedia,opencalais,saplo,textrazor,wikimeta,yahoo,zemanta,stanford,ritter,class" > $x.csv ; sed 's/,/COMMA/g ; s/"/DQUOTE/g ; s/`/backtick/g ; s/\%/percent/g ' < $x | sed "s/'/quote/g" | gtr " " "," | sed '/^$/d' >> $x.csv ; \
    done

    for x in *conll ; \
      do echo "token,pos,initcap,allcaps,prefix,suffix,capitalisationfrequency,start,end,alchemy,spotlight,extractiv,lupedia,opencalais,saplo,textrazor,wikimeta,yahoo,zemanta,stanford,ritter,class" > $x.csv ; sed 's/,/COMMA/g ; s/"/DQUOTE/g ; s/`/backtick/g ; s/\%/percent/g ' < $x | sed "s/'/quote/g" | gtr " " "," | sed '/^$/d' >> $x.csv ; \
    done 

    echo "token,pos,initcap,allcaps,prefix,suffix,capitalisationfrequency,start,end,alchemy,spotlight,extractiv,lupedia,opencalais,saplo,textrazor,wikimeta,yahoo,zemanta,stanford,ritter,class" > nerdANDstanfordANDuwtwitternlpANDmlFeatures_completeDataset.csv ; 
    cat nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part1.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part2.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part3.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part4.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part5.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part6.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part7.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part8.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part9.mcoll nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part10.mcoll | sed 's/,/COMMA/g ; s/"/DQUOTE/g ; s/`/backtick/g ' | sed "s/'/quote/g ; s/\%/percent/g " | gtr " " "," | sed '/^$/d' >> nerdANDstanfordANDuwtwitternlpANDmlFeatures_completeDataset.csv

##### classifier

    export CLASSPATH=$CLASSPATH:/where/weka/is/located/weka.jar
    java weka.core.converters.CSVLoader MachineLearningExperiments/nerdANDstanfordANDuwtwitternlpANDmlFeatures_completeDataset.csv > MachineLearningExperiments/nerdANDstanfordANDuwtwitternlpANDmlFeatures_completeDataset.arff


Copy arff header from big file to small files to ensure WEKA's compatibility:

    head -n30 MachineLearningExperiments/nerdANDstanfordANDuwtwitternlpANDmlFeatures_completeDataset.arff > MachineLearningExperiments/March19arffHeader.txt


Convert all csv files to arff and add big header:

    for x in MachineLearningExperiments/*csv ; \
      do cat  MachineLearningExperiments/March19arffHeader.txt > ${x%csv}arff ; \
      java weka.core.converters.CSVLoader $x | sed '1,30d' >> ${x%csv}arff ; \
    done 


Launch a classifier. For the sake of brevity here is reported the KNN:

    for x in {1..10}; \
    do \
      java -mx4g weka.classifiers.lazy.IBk -t MachineLearningExperiments/TrainingRun$x.conll.arff -T MachineLearningExperiments/nerdANDstanfordANDuwtwitternlpANDmlFeatures_Part$x.mcoll.arff -p 1 > MachineLearningExperiments/March19IB1_WEKA_output_Run$x.txt ;\
    done


Convert to CoNLL format:

    for x in {1..10} ; \
    do \
      perl Scripts/ReformatWekaOutputToCoNLL.pl March19IB1_WEKA_output_Run$x.txt > March19IB1_WEKA_output_Run$x_forConllFULL.txt ; \
    done 


Concatenate and check performance:
    
    for x in {1..10} ; \
    do \ 
      cat March19IB1_WEKA_output_Run$x_forConll.txt >> March19IB1_WekaOutput_bigfileFULL.txt;
    done

Compute scores:

    perl Scripts/conlleval.pl < March19IB1_WekaOutput_bigfile.txt 

#### Licence
These scripts are free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License published by
the Free Software Foundation, either version 3 of the License, or (at 
your option) any later version. See the file Documentation/GPL3 in the
original distribution for details. There is ABSOLUTELY NO warranty. 
