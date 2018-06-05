#!/bin/bash

#SBATCH -c 3
#SBATCH --mem=4096
#SBATCH --time=0-2:0:00


POPUPDATES=50000 #which detail file should be taken and how event file should be configured    
POPCYCLES=3 #number of populations you are making
ANTIUPDATES=50000 #how event should be configured for antibiotic run
ANTICYCLES=2 #number of antibiotic runs each version of population gets
SEARCHINSTR='add' #instruction we want to exist so we can make it antibiotic
MOVED=3
#prepare workantiadd to run multiple times
cd cbuild/workantiadd
sed -i "40s/data/data1-1/" avida.cfg  #change data to data1 for while loop

#getting event file in antibiotic set to run enough updates
sed -i "37s/100000/$ANTIUPDATES/" events.cfg

#get event files ready to load different populations
sed -i "17s/detail.spop/detail-$POPUPDATES-1.spop/" events.cfg

#run the anti cycles on all the moved populations
CURR=1
while ((CURR<=MOVED))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file

	SUBCURR=1
	while ((SUBCURR<=ANTICYCLES))
	do
		((SUBNEXT = SUBCURR + 1))
		./avida > "logfile$CURR-$SUBCURR" &           # run avida in the background
		sleep 2		
		sed -i "40s/data$CURR-$SUBCURR/data$CURR-$SUBNEXT/" avida.cfg # change data outputfile by 1
		((SUBCURR=SUBCURR+1))
	done

	sed -i "40s/data$CURR-$SUBNEXT/data$NEXT-1/" avida.cfg

	sed -i "17s/detail-$POPUPDATES-$CURR.spop/detail-$POPUPDATES-$NEXT.spop/" events.cfg

	((CURR=CURR+1))
done
wait 

#reset events.cfg file
sed -i "17s/detail-$POPUPDATES-$CURR.spop/detail.spop/" events.cfg 
#reset the event updates
sed -i "37s/$ANTIUPDATES/100000/" events.cfg 

# reset data outputfile to 1
sed -i "40s/data$NEXT-1/data/" avida.cfg 

