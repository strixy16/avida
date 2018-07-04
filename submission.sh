#!/bin/bash

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

aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)
aINSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=(20 40 60 80 100)

for INSTR in ${aINSTR[@]} 
do
	for CONC in ${aCONC[@]}
	do
		for RXN in ${aRXNS[@]}
		do
			sed -i "${LINENUM}s|work|work$INSTR$CONC/run$RXN|" multi.sh
			sbatch ./multi.sh
			sed -i "${LINENUM}s|work$INSTR$CONC/run$RXN|work|" multi.sh
		done
	done
done
