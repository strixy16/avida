#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=10240
#SBATCH --time=0-12:0:00

aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)
aINSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=(20 40 60 80 100)

# Find line number to change concentration value
CONCLINE=$(grep -n -m 1 "CONCENTRATION" changeConcentration.sh | cut -f1 -d:) 
for INSTR in ${aINSTR[*]}
do
	sed -i -E "s/\[\"${INSTR}\"\]=false/\[\"${INSTR}\"\]=true/" changeConcentration.sh  #choose which instruction

	for CONC in ${aCONC[*]}
	do
		sed -i -E "s/CONCENTRATION=[0-9]+/CONCENTRATION=$CONC/" changeConcentration.sh 	#set concentration
		./changeConcentration.sh
		sed -i "s/CONCENTRATION=$CONC/CONCENTRATION=0/" changeConcentration.sh 	#reset concentration
	done

	sed -i -E "s/\[\"${INSTR}\"\]=true/\[\"${INSTR}\"\]=false/" changeConcentration.sh  #turn off instruction
done


cd cbuild
for INSTR in ${aINSTR[*]}
do
	for CONC in ${aCONC[*]}
	do
		cd work$INSTR$CONC   #go into the specific work folder
		mkdir run 
		mv * run/    #move all the files into run
		
		for RXN in ${aRXNS[*]}
		do
			cp -R run run$RXN		#make folder for specific task
			cd run$RXN
			
			sed -i -E "s/BIRTH_METHOD [0-9]+/BIRTH_METHOD 4/" avida.cfg # Make population well mixed

			sed -i -E "s/REQUIRED_REACTION -*[0-9]+/REQUIRED_REACTION 0/" avida.cfg	#change the required reaction	
			# Change events to load population from ancestors
			sed -i "/u begin/c\u begin LoadPopulation ..\/..\/work$RXN\/data\/detail.spop" events.cfg
			
			# Disable all but the tested reaction in environment file 
			sed -i "s/REACTION/#REACTION/" environment.cfg
			sed -i -E "s/#REACTION\s+$RXN/REACTION  $RXN/" environment.cfg
			cd ..
		done 
		rm -R run/
		cd ..
	done 
done 
