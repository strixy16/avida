#!/bin/bash

# Script for generating ancestor populations for antibiotic trials
# Assumes that desired settings have already been set in multi.sh

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

source ./variables.sh

# Save number of runs from variables file
oldRUNS=$(grep "RUNS=" variables.sh | cut -d= -f2)

# Start runs for each reaction
for RXN in ${aRXNS[@]}
do
	# Run 5 trials for XOR and EQU
        if [[ $RXN == XOR ]] || [[ $RXN == EQU ]]
        then
                sed -i -E "s/RUNS=[0-9]/RUNS=5/" variables.sh
        # Only run 1 trial for the rest of the reactions
        else
                sed -i -E "s/RUNS=[0-9]/RUNS=1/" variables.sh
        fi
	
	# Reload variables with updated RUNS count
	source ./variables.sh 
	
	sed -i -E "s|cd cbuild/work\w*|cd cbuild/work$RXN|" multi.sh
	sbatch ./multi.sh
	sed -i -E "s|cd cbuild/work$RXN|cd cbuild/work|" multi.sh
done

# Return RUNS to value it was set at before this script
sed -i -E "s/RUNS=[0-9]/RUNS=${oldRUNS}/" variables.sh
