#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=2048
#SBATCH --time=0-0:2:00


#stuff to chose
#NOTE: if less than 500, won't save population, need to change by hand
POPUPDATES=100 #which detail file should be taken and how event file should be configured    
POPCYCLES=1 #number of populations you are making
ANTIUPDATES=100 #how event should be configured for antibiotic run
ANTICYCLES=2 #number of antibiotic runs each version of population gets
SEARCHINSTR='add' #instruction we want to exist so we can make it antibiotic
#need to have workdefault having PrintDominantGenotype uncommented
#make sure to change the number so it only happens at the end

#getting event file in antibiotic set to run enough updates
cd cbuild/workantiadd
sed -i "37s/100000/$ANTIUPDATES/" events.cfg

#gettiing event file in default to have correct number of runs
cd ../workdefault    # go into correct directory
sed -i "40s/100000/$POPUPDATES/" events.cfg 

#setting so saves data of multiple runs in different folders
sed -i "40s/data/data1/"  #change data to data1 for while loop



#run normal avida
CURR=1                  #version of data file you start with
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
    sleep 2	
	sed -i "40s/data$CURR/data$NEXT/" # change data outputfile by 1
	((CURR=CURR+1))
done

# reset data outputfile to 1
sed -i "40s/data$NEXT/data/"

#reset event file to 100000
sed -i "40s/$POPUPDATES/100000/" events.cfg 
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
sed -i "40s/data/data1-1/"  #change data to data1 for while loop

#get event files ready to load different populations
sed -i "17s/detail.spop/detail-$POPUPDATES-1.spop/"

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
		sed -i "40s/data$CURR-$SUBCURR/data$CURR-$SUBNEXT/" # change data outputfile by 1
		((SUBCURR=SUBCURR+1))
	done

	sed -i "40s/data$CURR-$SUBNEXT/data$NEXT-1/"

	sed -i "17s/detail-$POPUPDATES-$CURR.spop/detail-$POPUPDATES-$NEXT.spop/"

	((CURR=CURR+1))
done

#reset events.cfg file
sed -i "17s/detail-$POPUPDATES-$CURR.spop/detail.spop/"
#reset the event updates
sed -i "40s/$ANTIUPDATES/100000/" events.cfg 

# reset data outputfile to 1
sed -i "40s/data$NEXT-1/data/"
wait
