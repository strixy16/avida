#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-6:0:00

#choose variables and which work folder
TIMESRUN=6             #number of times you run avida
POPUPDATES=100000
cd cbuild/work          # go into correct directory

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
