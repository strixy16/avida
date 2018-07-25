#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

source ./variables.sh

#choose which run folder in which work folder this runs in
cd cbuild/work/run

#make backups so don't change stuff for this run
mv events.cfg eventbackup
mv avida.cfg avidabackup
touch events.cfg 
touch avida.cfg

sed -E "s/([0-9]+) Exit/$POPUPDATES Exit/" eventbackup > events.cfg #has correct number of updates
sed -E "
	s/DATA_DIR [[:alnum:]]+/DATA_DIR nomutdata1/
	s/COPY_MUT_PROB [0-9]*\.*[0-9]*/COPY_MUT_PROB 0.0/
	s/DIVIDE_INS_PROB [0-9]*\.*[0-9]*/DIVIDE_INS_PROB 0.0/
	s/DIVIDE_DEL_PROB [0-9]*\.*[0-9]*/DIVIDE_DEL_PROB 0.0/" avidabackup > avida.cfg #get rid of mutation

#looks at data files to see if some already exist and need to be moved
LIST=$(find . -maxdepth 1 -type d -name "nomutdata*")
for dataFile in $LIST; do
    if [[ $dataFile == ./nomutdata[1-$RUNS] ]]; then
        #makes new old folder and only one per run of multi
        NUM=1
        while [[ -d oldnomut$NUM ]]; do
            ((NUM=NUM+1))
        done
        mkdir oldnomut$NUM
        break
    fi
done

#moves data files into old
for (( i = 0; i <= $RUNS; i++ )); do
    if [ -d nomutdata$i ]; then
        echo "data$i already exists, moving to old$NUM"
        mv nomutdata$i oldnomut$NUM
    fi
done

#running avida
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


