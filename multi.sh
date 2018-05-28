#!/bin/bash

#SBATCH -c 2		 # number of CPUS (default 2)
#SBATCH --mem=5120	 # memory allocated for job (default 5G)
#SBATCH --time=0-4:0:00  # time for job to run (default 4)

cd cbuild/work          # go into correct directory

sed "40s/data/data1/" avida.cfg > temp  #change data to data1 for while loop
cat temp > avida.cfg

CURR=1                  #version of data file you start with
while ((CURR<=5))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
        sleep 2	
	sed "40s/data$CURR/data$NEXT/" avida.cfg > temp # change data outputfile by 1
	cat temp > avida.cfg
	rm temp
	((CURR=CURR+1))

# reset data outputfile to 1
sed "40s/data$NEXT/data1/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait
