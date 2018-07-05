#!/bin/bash

# Script for generating ancestor populations for antibiotic trials
# Assumes that desired settings have already been set in multi.sh

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

source ./variables.sh

#aRXNS=(NAND AND ORN OR ANDN NOR XOR EQU)
# Start runs for each reaction
for RXN in ${aRXNS[@]}
do
	sed -i -E "s|cd cbuild/work\w*|cd cbuild/work$RXN|" multi.sh
	sbatch ./multi.sh
	sed -i -E "s|cd cbuild/work$RXN|cd cbuild/work|" multi.sh
done
