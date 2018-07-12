#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=3072
#SBATCH --time=0-2:0:00

source ./variables.sh

for INSTR in ${aINSTR[@]} 
do
	for CONC in ${aCONC[@]}
	do
		for RXN in ${aRXNS[@]}
		do
			#runs noMut script if mutation run, multi if regular
			if [[ $noMut == true ]]; then
				sed -i -E "s|cbuild/[[:alnum:]]*/*[[:alnum:]]*|cbuild/work$INSTR$CONC/run$RXN|" noMut.sh
				sbatch noMut.sh
				sed -i -E "s|cbuild/work$INSTR$CONC/run$RXN|cbuild/work/run|" noMut.sh
			else
				sed -i -E "s|work|work$INSTR$CONC/run$RXN|" multi.sh
				sbatch multi.sh
				sed -i "s|work$INSTR$CONC/run$RXN|work|" multi.sh
			fi

		done
	done
done
