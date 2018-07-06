#!/bin/bash

#SBATCH -c 2
#SBATCH --mem=3072
#SBATCH --time=0-4:0:00

source ./variables.sh

#only do fully blocked instructions for this, so overwrite other list
aCONC=(100)

cd cbuild

for INSTR in ${aINSTR[@]} 
do
	for CONC in ${aCONC[@]}
	do
		cd work$INSTR$CONC

		for RXN in ${aRXNS[@]}
		do
			cd run$RXN

			#make backups so don't change stuff for this run
			mv events.cfg eventbackup
			mv avida.cfg avidabackup
			touch events.cfg 
			touch avida.cfg

			sed -E "s/([0-9]+) Exit/500 Exit/" eventbackup > events.cfg #onlny run for 500 updates
			sed -E "
				s/DATA_DIR [[:alnum:]]+/DATA_DIR nomutdata/
				s/COPY_MUT_PROB [[:alnum:]]+/COPY_MUT_PROB 0.0/
				s/DIV_INS_PROB [[:alnum:]]+/DIV_INS_PROB 0.0/
				s/DIV_DEL_PROB [[:alnum:]]+/DIV_DEL_PROB 0.0/" avidabackup > avida.cfg #get rid of mutation

			./avida
			wait

			#return to default mutation settings
			rm events.cfg
			rm avida.cfg
			mv eventbackup events.cfg
			mv avidabackup avida.cfg

			cd ..

		done

		cd ..
	done
done
