#!/bin/bash

#SBATCH -c 4
#SBATCH --mem=3072
#SBATCH --time=2-0:0:00

cd cbuild/work          # go into correct directory


CURR=1                  #version of data file you start with
TIMESRUN=6             #number of times you run avida
arr=(0.0025 0.005 0.0075 0.01 0.05 0.1) #starts at 0.0025 already in file
i=0
while ((CURR<=TIMESRUN))
do
    ((NEXT = CURR + 1)) # index of next data file
    ./avida > "logfile$CURR" &           # run avida in the background
    sleep 2                              #stop avida overiding itself when change config
    sed "40s/data$CURR/data$NEXT/" avida.cfg > temp # change data outputfile by 1
    cat temp > avida.cfg
    rm temp
    ((CURR=CURR+1))
    #put any changes to the config here
    ((nexti = i + 1 ))
    sed "55s/${arr[i]}/${arr[nexti]}/" avida.cfg > temp
    cat temp > avida.cfg
    rm temp
done

# reset data outputfile to 1
sed "40s/data$NEXT/data/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait
