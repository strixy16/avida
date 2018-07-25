#!/bin/bash

# Script for generating ancestor populations for antibiotic trials
# Assumes that desired settings have already been set in multi.sh

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

source ./variables.sh

# Start runs for each reaction
for RXN in ${aRXNS[@]}
do
	# Run 5 trials for XOR and EQU
        if [[ $RXN == XOR ]] || [[ $RXN == EQU ]]
        then
                sed -i '/source .\/variables/aRUNS=5' multi.sh
        # Only run 1 trial for the rest of the reactions
        else
                sed -i '/source .\/variables/aRUNS=1' multi.sh
        fi
	
	sed -i -E "s|cd cbuild/work\w*|cd cbuild/work$RXN|" multi.sh
	sbatch ./multi.sh
	sed -i -E "s|cd cbuild/work$RXN|cd cbuild/work|" multi.sh
	sed -i -E '/RUNS=[0-9]/d' multi.sh
done
