#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=3072
#SBATCH --time=0-4:0:00

CURR=1                  #version of data file you start with
TIMESRUN=5             #number of times you run avida
POPUPDATES=100000		#how many updates

cd cbuild/work_all          # go into correct directory

#change updates in event file
sed -i "37s/100000/$POPUPDATES/" events.cfg 
sed -i "28s/100000/$POPUPDATES/" events.cfg

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

#reset event file to 100000
sed -i "37s/$POPUPDATES/100000/" events.cfg 
sed -i "28s/$POPUPDATES/100000/" events.cfg 

# reset data outputfile to 1
sed -i "40s/data$NEXT/data/" avida.cfg
wait
