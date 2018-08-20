#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=10240
#SBATCH --time=0-12:0:00

source ./variables.sh

#makes sure no problems with leftover settings
sed -i -E "s/(instr.*=)true/\1false/" changeConcentration.sh #all instructions off
sed -i -E "s/(rxn.*=)false/\1true/" changeConcentration.sh  #all reactions on

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

		sed -i -E "s/BIRTH_METHOD [0-9]+/BIRTH_METHOD 4/" avida.cfg # Make population well mixed
		sed -i -E "s/REQUIRED_REACTION -*[0-9]+/REQUIRED_REACTION 0/" avida.cfg	#change the required reaction

		# Energy settings
		if [[ $energy==true ]]
		then
			# Set mutation rate for energy run
			sed -i -E "s/COPY_MUT_PROB [0-9]*\.[0-9]*/COPY_MUT_PROB 0.00025/" avida.cfg

			# Turn on energy settings
			sed -i -E "s/ENERGY_ENABLED [0-9]/ENERGY_ENABLED 1/" avida.cfg
			sed -i -E "s/ENERGY_GIVEN_ON_INJECT [0-9]*/ENERGY_GIVEN_ON_INJECT 500/" avida.cfg
			sed -i -E "s/NUM_CYCLES_EXC_BEFORE_0_ENERGY [0-9]*/NUM_CYCLES_EXC_BEFORE_0_ENERGY 1000/" avida.cfg
			sed -i -E "s/APPLY_ENERGY_METHOD [0-9]*/APPLY_ENERGY_METHOD 1/" avida.cfg
		fi

		mkdir run 
		mv $(ls | grep -v run) run/    #move all the files into run without moving run into run

		for RXN in ${aRXNS[*]}
		do
			cp -R run run$RXN		#make folder for specific task
			cd run$RXN

			# Change events to load population from ancestors
			sed -i "/u begin/c\u begin LoadPopulation ..\/..\/work$RXN\/data\/detail.spop" events.cfg

			# Disable all but the tested reaction in environment file 
			sed -i "s/REACTION/#REACTION/" environment.cfg
			sed -i -E "s/#REACTION\s+$RXN /REACTION  $RXN/" environment.cfg

			# Energy settings
			if [[ $energy==true ]]
			then
				# Insert resource line
				if ! grep -q RESOURCE environment.cfg
				then
					sed -i '14iRESOURCE sunlight:initial=1.0:inflow=10:outflow=0.1' environment.cfg
				fi

				# Replace reaction line with energy settings
				# Need to add proper max counts and value for proper resource
				enRXN=${RXN,,}
				sed -i -E "s/${enRXN}\s*process.*/${enRXN}   process:resource=sunlight:value=1000.0:type=energy:frac=1.0:product=sunlight:conversion=1.0 requisite:max_count=35/" environment.cfg
			fi

			cd ..
		done 
		rm -R run/
		cd ..
	done 
done 

