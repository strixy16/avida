#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=2048
#SBATCH --time=0-0:2:00


#stuff to chose
POPUPDATES=100 #which detail file should be taken     
POPCYCLES=1 #number of populations you are making
ANTICYCLES=1 #number of antibiotic runs each version of population gets

#setting so saves data of multiple runs in different folders
cd ../../../cbuild/workdefault    # go into correct directory
sed "40s/data/data1/" avida.cfg > temp  #change data to data1 for while loop
cat temp > avida.cfg
rm temp


#run normal avida
CURR=1                  #version of data file you start with
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
    sleep 2	
	sed "40s/data$CURR/data$NEXT/" avida.cfg > temp # change data outputfile by 1
	cat temp > avida.cfg
	rm temp
	((CURR=CURR+1))
done

# reset data outputfile to 1
sed "40s/data$NEXT/data/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait

#move data files into workantiadd labeled with which run
CURR=1
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	cd data$CURR
	cp detail-$POPUPDATES.spop ../../workantiadd/populations/detail-$POPUPDATES-$CURR.spop
	cd ..
	((CURR=CURR+1))
done
wait

#prepare workantiadd to run multiple times
cd ../workantiadd
sed "40s/data/data1-1/" avida.cfg > temp  #change data to data1 for while loop
cat temp > avida.cfg
rm temp

#get event files ready to load different populations
sed "17s/detail.spop/detail-$POPUPDATES-1.spop/" events.cfg > temp
cat temp > events.cfg
rm temp


CURR=1

while ((CURR<=POPCYCLES))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file

	SUBCURR=1
	while ((SUBCURR<=ANTICYCLES))
	do
		((SUBNEXT = SUBCURR + 1))
		./avida > "logfile$CURR-$SUBCURR" &           # run avida in the background
		sleep 2		
		sed "40s/data$CURR-$SUBCURR/data$CURR-$SUBNEXT/" avida.cfg > temp # change data outputfile by 1
		cat temp > avida.cfg
		rm temp
		((SUBCURR=SUBCURR+1))
	done

	sed "40s/data$CURR-$SUBNEXT/data$NEXT-1/" avida.cfg > temp
	cat temp > avida.cfg
	rm temp

	sed "17s/detail-$POPUPDATES-$CURR.spop/detail-$POPUPDATES-$NEXT.spop/" events.cfg > temp
	cat temp > events.cfg
	rm temp

	((CURR=CURR+1))
done

#reset events.cfg file
sed "17s/detail-$POPUPDATES-$CURR.spop/detail.spop/" events.cfg > temp
cat temp > events.cfg
rm temp

# reset data outputfile to 1
sed "40s/data$NEXT-1/data/" avida.cfg > temp
cat temp > avida.cfg
rm temp
wait
