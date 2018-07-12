#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=3072
#SBATCH --time=0-1:0:00


source ./variables.sh

if [[ $noMut == true ]]; then
	#makes sure doens't write to bottom of taskDataNoMut
	if [ -f taskDataNoMut ]; then
		echo "taskDataNoMut already exists"
		read -p "Enter a new name for the already existing taskDataNoMut to be changed to : " NAME 
		while [ -f $NAME ]; do
			read -p "Name already exists, try again: " NAME
		done
		mv taskDataNoMut $NAME
	fi

	WRITETO=taskDataNoMut
	touch $WRITETO
else
	#makes sure don't just write to bottom of already existing taskData
	if [ -f taskData ]; then
		echo "taskData already exists"
		read -p "Enter a new name for the already existing taskData to be changed to : " NAME 
		while [ -f $NAME ]; do
			read -p "Name already exists, try again: " NAME
		done
		mv taskData $NAME
	fi

	WRITETO=taskData
	touch $WRITETO
fi


cd cbuild

for RXN in ${aRXNS[@]} 
do
	echo $RXN >> ../$WRITETO

	for INSTR in ${aINSTR[@]}
	do
		echo $INSTR >> ../$WRITETO

		for CONC in ${aCONC[@]}
		do
			cd work$INSTR$CONC/run$RXN

			if [[ $noMut == true ]]; then
				##this code will read the noMut run
				for (( i = 1; i <= $RUNS; i++ )); do
					if [ -d nomutdata$i ]; then
						cd nomutdata$i
						TASK=$(tail -1 tasks.dat)
						echo "$CONC $TASK" >> ../../../../$WRITETO
						cd ..
					else
						echo "does not exist" >> ../../../$WRITETO
					fi
				done
			else
				#this code reads a regular run with 5 runs per run folder
				for (( i = 1; i <= $RUNS; i++ )); do
					if [ -d data$i ]; then
						cd data$i
						TASK=$(tail -1 tasks.dat)
						echo "$CONC $TASK" >> ../../../../$WRITETO
						cd ..
					else
						echo "does not exist" >> ../../../$WRITETO
					fi
				done

			fi


			cd ../..
		done

	done
done
