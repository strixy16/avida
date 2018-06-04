#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=2048
#SBATCH --time=0-0:2:00


#stuff to chose
POPUPDATES=100 #which detail file should be taken NOTE:need to change in event file    
POPCYCLES=1 #number of populations you are making
ANTICYCLES=2 #number of antibiotic runs each version of population gets
SEARCHINSTR='add' #instruction we want to exist so we can make it antibiotic
#need to have workdefault having PrintDominantGenotype uncommented
#make sure to change the number so it only happens at the end

#setting so saves data of multiple runs in different folders
cd cbuild/workdefault    # go into correct directory
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
MOVED=1
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	cd data$CURR
	#checking if instruction is actually in dominant
	grep -qi $SEARCHINSTR archive/*.org
	greprc=$?
	if [[ $greprc -eg 0 ]]; then
		cp detail-$POPUPDATES.spop ../../workantiadd/populations/detail-$POPUPDATES-$MOVED.spop
		((MOVED=MOVED+1))	
	elif [[ $greprc -eq 1 ]]; then
		echo "population $CURR doesn't have instruction in dominant"
	else
		echo "something went wrong with grep"

	cd ..
	((CURR=CURR+1))
done
wait

#this is how many got successfully moved
((MOVED=MOVED-1)) 

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
