#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-8:0:00

source ./variables.sh

for INSTR in ${aINSTR[@]} 
do
	for CONC in ${aCONC[@]}
	do
		for RXN in ${aRXNS[@]}
		do
			sed -i -E "s|work|work$INSTR$CONC/run$RXN|" multi.sh
			sbatch ./multi.sh
			sed -i "${LINENUM}s|work$INSTR$CONC/run$RXN|work|" multi.sh
		done
	done
done
