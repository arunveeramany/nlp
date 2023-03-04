#!/usr/bin/env bash 

set -x

export S2S_HOME=$(pwd)
rm -rf work
mkdir -p work
export WORK=$S2S_HOME/work
cd ../../
export TEXT2SQL_HOME=$(pwd)
cd $TEXT2SQL_HOME/tools
python2 new_format_processor.py $TEXT2SQL_HOME/data/academic.json $WORK/academic_data/


cd $WORK/academic_data/
cd query_split/
mkdir train
mv 0 ..
find . -type f -name *encode.txt* -exec cat {} + > merged_train.txt
mv merged_train.txt train/train_encode.txt
find . -type f -name *decode.txt* -exec cat {} + > merged_train.txt
mv merged_train.txt train/train_decode.txt 
mv ../0 .
rm -rf test
cp -rf 0 test
cd test
mv 0_encode.txt test_encode.txt
mv 0_decode.txt test_decode.txt
cd ..
cp -rf train dev
cd dev
mv train_encode.txt dev_encode.txt
mv train_decode.txt dev_decode.txt



cd $WORK/academic_data/
cd question_split/
mv 0 ..
find . -type f -name *encode.txt* -exec cat {} + > merged_train.txt
mkdir train test
mv merged_train.txt train/train_encode.txt
find . -type f -name *decode.txt* -exec cat {} + > merged_train.txt
mv merged_train.txt train/train_decode.txt

mv ../0 .
rm -rf test
cp -rf 0 test
cd test
mv 0_encode.txt test_encode.txt
mv 0_decode.txt test_decode.txt
cd ..

cp -rf train dev
cd dev
mv train_encode.txt dev_encode.txt
mv train_decode.txt dev_decode.txt



cd $S2S_HOME
python2 make_schema_loc_file.py $WORK/academic_data/query_split/ $TEXT2SQL_HOME/data/academic-schema.csv
python2 make_schema_loc_file.py $WORK/academic_data/question_split/ $TEXT2SQL_HOME/data/academic-schema.csv
cd bin/tools
python2 generate_copying_vocab.py $WORK/academic_data/query_split/
python2 generate_copying_vocab.py $WORK/academic_data/question_split/


rm ~/text2sql-data/systems/sequence-to-sequence/models/copy_input/academic_query_split/model*
rm ~/text2sql-data/systems/sequence-to-sequence/models/copy_input/academic_query_split/checkpoint*


#After this  prep
#cd ~/text2sql-data/systems/sequence-to-sequence/models/copy_input/academic_query_split
#./experiment.sh

#To kill ongoing experiment; repeatedly run these
#pkill -f experiment
#pkill -f python2
