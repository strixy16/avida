#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=3072
#SBATCH --time=0-4:0:00

cd cbuild/work          # go into correct directory

sed "40s/data/data1/" avida.cfg > temp  #change data to data1 for while loop
cat temp > avida.cfg

CURR=1                  #version of data file you start with
TIMESRUN=4             #number of times you run avida
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
    if ((CURR==3)); then #after 2 runs, switch to starting with 0.1
        sed "55s/0.0025/0.1/" avida.cfg > temp
        cat temp > avida.cfg
        rm temp

    fi
    
done

# reset data outputfile to 1
sed "40s/data$NEXT/data/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait
