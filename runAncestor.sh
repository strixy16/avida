#!/bin/bash

# Script for generating ancestor populations for antibiotic trials
# Assumes that desired settings have already been set in multi.sh

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

# Checking that multi.sh is in default state
# Find cd cbuild/work line number
LINENUM=$(grep -n "cbuild/work" multi.sh | cut -f1 -d:) 
# Get line contents
CHECKLINE=$(sed "${LINENUM}q;d" multi.sh)
# If something is present after work, remove it
if [[ $CHECKLINE != "cd cbuild/work " ]]
then
	sed -i "${LINENUM}s|work\w*|work|" multi.sh
fi

aRXNS=(NAND AND ORN OR ANDN NOR XOR EQU)
# Start runs for each reaction
for RXN in ${aRXNS[@]}
do
	sed -i "${LINENUM}s|work|work$RXN|" multi.sh
	sbatch ./multi.sh
	sed -i "${LINENUM}s|work$RXN|work|" multi.sh
done
