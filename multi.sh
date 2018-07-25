#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-6:0:00

#number of updates is in variables.sh
source ./variables.sh

# go into correct directory
cd cbuild/work         


#change updates in event file
sed -i -E "s/[0-9]+ Exit/$POPUPDATES Exit/" events.cfg

#set up data to run multiple times
sed -i -E "s/DATA_DIR [[:alnum:]]*/DATA_DIR data1/" avida.cfg

#looks at data files to see if some already exist and need to be moved
LIST=$(find . -maxdepth 1 -type d -name "data*")
for dataFile in $LIST; do
    if [[ $dataFile == ./data[1-$RUNS] ]]; then
        #makes new old folder and only one per run of multi
        NUM=1
        while [[ -d old$NUM ]]; do
            ((NUM=NUM+1))
        done
        mkdir old$NUM
        break
    fi
done

#moves data files into old
for (( i = 0; i <= $RUNS; i++ )); do
    if [ -d data$i ]; then
        echo "data$i already exists, moving to old$NUM"
        mv data$i old$NUM
    fi
done


CURR=1                  #version of data file you start with
while ((CURR<=RUNS))
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
	sleep 2                              #stop avida overiding itself when change config
	sed -i "s/DATA_DIR data$CURR/DATA_DIR data$NEXT/" avida.cfg # change data outputfile by 1
	((CURR=CURR+1))
	#put any changes to the config here
done

# reset data outputfile to 1
sed -i "s/DATA_DIR data$NEXT/DATA_DIR data/" avida.cfg

wait
