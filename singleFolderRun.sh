#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=5072
#SBATCH --time=0-10:0:00

source ./variables.sh

LIST=("$@")

#don't do anything if it is an empty list
if [[ ${#LIST[@]} -ne 0 ]]; then

	# go into correct directory
	cd cbuild/work/run #gets chnaged by script running the file to make sure correct


	#make sure run for correct number of updates without losing what was there before
	mv events.cfg eventbackup
	touch events.cfg 
	sed -E "s/([0-9]+) Exit/$POPUPDATES Exit/" eventbackup > events.cfg #onlny run for 500 updates
	    
	if [[ $noMut == true ]]; then
	    mv avida.cfg avidabackup
	    touch avida.cfg

		#get rid of mutations
		sed -E "
			s/COPY_MUT_PROB [0-9]*\.*[0-9]*/COPY_MUT_PROB 0.0/
			s/DIVIDE_INS_PROB [0-9]*\.*[0-9]*/DIVIDE_INS_PROB 0.0/
			s/DIVIDE_DEL_PROB [0-9]*\.*[0-9]*/DIVIDE_DEL_PROB 0.0/" avidabackup > avida.cfg #get rid of mutation
	fi

	for i in ${LIST[@]}; do
	    #print to the right place
	    sed -i "s/DATA_DIR [[:alnum:]]*/DATA_DIR $i/" avida.cfg
	    ./avida
	    sleep 2
	done

	if [[ $noMut == true ]]; then
	    #return avida to previous setup
	    rm avida.cfg
	    mv avidabackup avida.cfg
	fi

	#return events to previous setup
	rm events.cfg
	mv eventbackup events.cfg

	#return data folder it prints out to to default
	sed -i "s/DATA_DIR [[:alnum:]]*/DATA_DIR data/" avida.cfg

	wait
fi
