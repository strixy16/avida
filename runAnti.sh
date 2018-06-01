#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=2048
#SBATCH --time=0-6:0:00

cd cbuild/origwork          # go into correct directory
sed "40s/data/data1/" avida.cfg > temp
CYCLES=1
CURR=1                  #version of data file you start with
while ((CURR<=CYCLES))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
        sleep 2	
	sed "40s/data$CURR/data$NEXT/" avida.cfg > temp # change data outputfile by 1
	cat temp > avida.cfg
	rm temp
	((CURR=CURR+1))
done

# reset data outputfile to data
sed "40s/data$NEXT/data/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait

CURR=1
while ((CURR<=CYCLES))       # number of times to run avida
do
	echo "start of getting Detail"
	cd data$CURR
	mv detail-10000.spop ../../work_$CURR
	cd ..
	echo "detail moved"
	CURR=CURR+1
done
cd ..
CURR=1
while ((CURR<=CYCLES))       # number of times to run avida
do
	echo "start of running avida"
	cd work_$CURR
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
        sleep 2	
	((CURR=CURR+1))
	cd ..
done
wait
