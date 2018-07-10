# Create ancestor work folders for use in antibiotic trials
#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=1024
#SBATCH --time=0-3:0:00

source variables.sh
POPUPDATES=100000

cd cbuild
for RXN in ${aRXNS[*]}
do
	cp -R work work$RXN
	cd work$RXN

	# Set mutation rate lower
	sed -i -E "s/COPY_MUT_PROB [0-9]*\.[0-9]*/COPY_MUT_PROB 0.0025/" avida.cfg

	# Print dominant genotype file
	sed -i "s/# u 100:100 PrintDominantGenotype/u $POPUPDATES PrintDominantGenotype/" events.cfg 

	# NOT through ANDN settings
	if [[ $RXN != "NOR" ]] &&  [[ $RXN != "XOR" ]] && [[ $RXN != "EQU" ]]
	then
		# Disable all reactions except desired reaction in environment file 
		sed -i "s/REACTION/#REACTION/" environment.cfg
		sed -i -E "s/#REACTION\s+$RXN/REACTION  $RXN/" environment.cfg
	# NOR, XOR, EQU require all reactions below them to be enabled
	elif [[ $RXN == "NOR" ]]
	then
		sed -i -E "s/REACTION\s+XOR/#REACTION  XOR/" environment.cfg
		sed -i -E "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
	elif [[ $RXN == "XOR" ]]
	then
		sed -i "s/REACTION\s+EQU/#REACTION  EQU/" environment.cfg
	else
		continue
	fi

	cd ..
done

