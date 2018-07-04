#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=3072
#SBATCH --time=0-2:0:00

aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)
aINSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=(20 40 60 80 100)

# Find line number to change concentration value
CONCLINE=$(grep -n -m 1 "CONCENTRATION" changeConcentration.sh | cut -f1 -d:) 
for INSTR in ${aINSTR[*]}
do
	# Get line number of instruction
	iLINE=$(grep -n "instr\[\"$INSTR\"\]" changeConcentration.sh | cut -f1 -d:)
	sed -i "${iLINE}s/false/true/" changeConcentration.sh  #choose which instruction

	for CONC in ${aCONC[*]}
	do
		sed -i "${CONCLINE}s/CONCENTRATION=0/CONCENTRATION=$CONC/" changeConcentration.sh 	#set concentration
		./changeConcentration.sh
		sed -i "${CONCLINE}s/CONCENTRATION=$CONC/CONCENTRATION=0/" changeConcentration.sh 	#reset concentration
	done

	sed -i "${iLINE}s/true/false/" changeConcentration.sh  #turn off instruction
done


cd cbuild
for INSTR in ${aINSTR[*]}
do
	for CONC in ${aCONC[*]}
	do
		cd work$INSTR$CONC   #go into the specific work folder
		#sed -i "49s/0.0075/0.0025/" avida.cfg  #change its copy mutation
		mkdir run 
		mv * run/    #move all the files into run
		
		for RXN in ${aRXNS[*]}
		do
			cp -R run run$RXN		#make folder for specific task
			cd run$RXN
			# Get line number to change require reaction
			REQLINE=$(grep -n "REQUIRED_REACTION" avida.cfg | cut -f1 -d:)
			sed -i "${REQLINE}s/-1/0/" avida.cfg	#change the required reaction
			
			# Change events to load population from ancestors
			sed -i "/u begin/c\u begin LoadPopulation ..\/..\/work$RXN\/data\/detail.spop" events.cfg
			
			# Disable all but the tested reaction in environment file 
			RXNLINE=$(grep -n " $RXN " environment.cfg | cut -f1 -d:)			
			sed -i "s/REACTION/#REACTION/" environment.cfg
			sed -i "${RXNLINE}s/#REACTION/REACTION/" environment.cfg
			#for I in 15 16 17 18 19 20 21 22 23 
			#do 
			#	if [[ I -gt LINE ]] || [[ I -lt LINE ]]	#
			#	then
			#		sed -i "${I}s/^/#/" environment.cfg
			#	fi
			#done 
			cd ..
		done 
		rm -R run/
		cd ..
	done 
done 

