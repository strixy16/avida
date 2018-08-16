# Create ancestor work folders for use in antibiotic trials
#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=1024
#SBATCH --time=0-3:0:00

source ./variables.sh

cd cbuild/work

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
else
	# Set mutation rate for general run
	sed -i -E "s/COPY_MUT_PROB [0-9]*\.[0-9]*/COPY_MUT_PROB 0.0025/" avida.cfg
fi

# Make birth method well-mixed
sed -i -E "s/BIRTH_METHOD [0-9]*/BIRTH_METHOD 4/" avida.cfg

# Print dominant genotype file
sed -i "s/# u 100:100 PrintDominantGenotype/u $POPUPDATES PrintDominantGenotype/" events.cfg

cd ..

# Make old populations folder if it doesn't exist
if [[ ! -d "oldPopulations" ]]
then
	mkdir oldPopulations
fi

for RXN in ${aRXNS[*]}
do
	# If old version of work folder exists, move to oldPopulations
	if [[ -d "work$RXN" ]]
	then
		dt=$(date '+_%m/%d_%H:%M')
		# Add current date/time onto old population directory
		mv work$RXN work$RXN$dt
		mv -R work$RXN$dt oldPopulations/
	fi

	cp -R work work$RXN
	cd work$RXN

	# Configure environment.cfg for energy run
	if [[ $energy==true ]]
	then
		# Insert resource line
		if ! grep -q RESOURCE environment.cfg
		then
			sed -i '14iRESOURCE sunlight:initial=1.0:inflow=10:outflow=0.1' environment.cfg
		fi

		# Change all reaction lines to energy settings
		# Need to add proper max counts and value for each resource
		for item in ${aRXNs}
		do 
			item=${item,,}
			sed -i -E "s/${item}\s*process.*/${item}   process:resource=sunlight:value=1000.0:type=energy:frac=1.0:product=sunlight:conversion=1.0 requisite:max_count=35/" environment.cfg
		done

	fi

	# NOT through ANDN settings
	if [[ $RXN != "NOR" ]] &&  [[ $RXN != "XOR" ]] && [[ $RXN != "EQU" ]]
	then
		# Disable all reactions except desired reaction in environment file 
		sed -i "s/REACTION/#REACTION/" environment.cfg
		sed -i -E "s/#REACTION\s+$RXN/REACTION  $RXN/" environment.cfg
		
		# NOR requires all reactions but XOR and EQU to be active
	elif [[ $RXN == "NOR" ]]
	then
		sed -i -E "s/REACTION\s+XOR/#REACTION  XOR/" environment.cfg
		sed -i -E "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
		# XOR requires all reactions but EQU to be active
	elif [[ $RXN == "XOR" ]]
	then
		sed -i "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
		# EQU leaves all other reactions active
	else
		continue
	fi

	cd ..
done

