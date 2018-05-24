#!/bin/bash
cd cbuild/work          # go into correct directory

CURR=1                  #version of data file you start with
while ((CURR<=2))       # number of times to run avida
do
    ((NEXT = CURR + 1)) # index of next data file
    ./avida &           # run avida in the background
    sleep 2
    sed "40s/version$CURR/version$NEXT/" avida.cfg > temp # change data outputfile by 1
    cat temp > avida.cfg
    rm temp
    ((CURR=CURR+1))
done

# reset data outputfile to 1
sed "40s/version$NEXT/version1/" avida.cfg > temp
cat temp > avida.cfg
rm temp
