#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=10072
#SBATCH --time=0-12:0:00

aRXNS=(NOT NAND AND ORN OR ANDN NOR XOR EQU)
aINSTR=(Nop-A Nop-B Nop-C If-n-equ If-less Pop Push Swap-stk Swap Shift-r Shift-l Inc Dec Add Sub Nand IO H-alloc H-divide H-copy H-search Mov-head Jmp-head Get-head If-label Set-flow)
aCONC=(20 40 60 80 100)

iCNT=0
for INSTR in ${aINSTR[*]}
do
	iLINE=$((11+iCNT))
	sed -i "${iLINE}s/false/true/" changeConcentration.sh  #choose which instruction
	
	for CONC in ${aCONC[*]}
	do
		sed -i "4s/CONCENTRATION=0/CONCENTRATION=$CONC/" changeConcentration.sh 	#set concentration
		./changeConcentration.sh
		sed -i "4s/CONCENTRATION=$CONC/CONCENTRATION=0/" changeConcentration.sh 	#set concentration


	done

	sed -i "${iLINE}s/true/false/" changeConcentration.sh  #turn off instruction
	iCNT=$((iCNT+1))
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
		CNTR=0
		for RXN in ${aRXNS[*]}
		do
			CNTR=$((CNTR+1))	#gonna need this for the environment file
			cp -R run run$RXN		#make folder for specific task
			LINE=$((17+CNTR))	#same as CNTR
			cd run$RXN
			sed -i "153s/-1/0/" avida.cfg	#change the required reaction
			sed -i "17s/^/#/" events.cfg
			sed -i "18iu begin LoadPopulation ../work$RXN/data/detail.spop" events.cfg
			for I in 15 16 17 18 19 20 21 22 23 
			do 
				if [[ I -gt LINE ]] || [[ I -lt LINE ]]	#
				then
					sed -i "${I}s/^/#/" environment.cfg
				fi
			done 
			cd ..
		done 
		rm -R run/
		cd ..
	done 
done 

