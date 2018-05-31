#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=3072
#SBATCH --time=0-4:0:00

cd cbuild   
for WORK in work*
do
	cd $WORK
	./avida > "logfile" &
	cd ..
done 
wait

