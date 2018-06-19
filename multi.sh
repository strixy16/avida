#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-4:0:00

CURR=1                  #version of data file you start with
TIMESRUN=5             #number of times you run avida
POPUPDATES=100000		#how many updates

cd cbuild/work		# go into correct directory

sed -i "40s/data/data1/" avida.cfg

while ((CURR<=TIMESRUN))
do
    ((NEXT = CURR + 1)) # index of next data file
    ./avida > "logfile$CURR" &           # run avida in the background
    sleep 2                              #stop avida overiding itself when change config
    sed -i "40s/data$CURR/data$NEXT/" avida.cfg # change data outputfile by 1
    ((CURR=CURR+1))
    #put any changes to the config here
done

# reset data outputfile to 1
sed -i "40s/data$NEXT/data/" avida.cfg
wait
