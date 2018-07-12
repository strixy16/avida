#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-6:0:00

#number of updates is in variables.sh
source ./variables.sh

#variables to adjust
TIMESRUN=5             #number of times you run avida
# go into correct directory
cd cbuild/work          


#change updates in event file
sed -i -E "s/[0-9]+ Exit/$POPUPDATES Exit/" events.cfg

#set up data to run multiple times
sed -i -E "s/DATA_DIR [[:alnum:]]+/DATA_DIR data1/" avida.cfg

CURR=1                  #version of data file you start with

while ((CURR<=TIMESRUN))
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
