#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=5072
#SBATCH --time=0-8:0:00

echo $1

# go into correct directory
# cd cbuild/work 

# if [[ $noMut == true ]]; then
# 	mv events.cfg eventbackup
# 	mv avida.cfg avidabackup
# 	touch events.cfg 
# 	touch avida.cfg

# 	#make sure run for correct number of updates
# 	sed -E "s/([0-9]+) Exit/$POPUPDATES Exit/" eventbackup > events.cfg #onlny run for 500 updates
# 	#get rid of mutations
# 	sed -E "
# 		s/COPY_MUT_PROB [0-9]*\.*[0-9]*/COPY_MUT_PROB 0.0/
# 		s/DIVIDE_INS_PROB [0-9]*\.*[0-9]*/DIVIDE_INS_PROB 0.0/
# 		s/DIVIDE_DEL_PROB [0-9]*\.*[0-9]*/DIVIDE_DEL_PROB 0.0/" avidabackup > avida.cfg #get rid of mutation


# fi