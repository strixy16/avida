#!/bin/bash

#SBATCH -c 6
#SBATCH --mem=8072
#SBATCH --time=1-0:0:00

source ./variables.sh

#choose which run folder in which work folder this runs in
cd cbuild/work/run

#make backups so don't change stuff for this run
mv events.cfg eventbackup
mv avida.cfg avidabackup
touch events.cfg 
touch avida.cfg

sed -E "s/([0-9]+) Exit/$POPUPDATES Exit/" eventbackup > events.cfg #onlny run for 500 updates
sed -E "
	s/DATA_DIR [[:alnum:]]+/DATA_DIR nomutdata1/
	s/COPY_MUT_PROB [0-9]*\.*[0-9]*/COPY_MUT_PROB 0.0/
	s/DIVIDE_INS_PROB [0-9]*\.*[0-9]*/DIVIDE_INS_PROB 0.0/
	s/DIVIDE_DEL_PROB [0-9]*\.*[0-9]*/DIVIDE_DEL_PROB 0.0/" avidabackup > avida.cfg #get rid of mutation

for (( i = 1; i <= $RUNS; i++ )); do
	./avida
	wait
	((NEXT=i+1))
	sed -i -E "s/nomutdata$i/nomutdata$NEXT/" avida.cfg
			
done


# return to default mutation settings
rm events.cfg
rm avida.cfg
mv eventbackup events.cfg
mv avidabackup avida.cfg


