#!/bin/bash

#SBATCH -c 4
#SBATCH --mem=4096
#SBATCH --time=1-0:0:00


#stuff to chose
#NOTE: if less than 500, won't save population, need to change by hand
POPUPDATES=50000 #which detail file should be taken and how event file should be configured    
POPCYCLES=2 #number of populations you are making
ANTIUPDATES=50000 #how event should be configured for antibiotic run
ANTICYCLES=2 #number of antibiotic runs each version of population gets
SEARCHINSTR='add' #instruction we want to exist so we can make it antibiotic
#need to have workdefault having PrintDominantGenotype uncommented
#make sure to change the number so it only happens at the end

#gettiing event file in default to have correct number of runs
cd cbuild/workORN    # go into correct directory
#sed -i "40s/100000/$POPUPDATES/" events.cfg 
#sed -i "30s/100000/$POPUPDATES/" events.cfg

#setting so saves data of multiple runs in different folders
sed -i "40s/data/data1/" avida.cfg  #change data to data1 for while loop


#run normal avida
CURR=1                  #version of data file you start with
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	((NEXT = CURR + 1)) # index of next data file
	./avida > "logfile$CURR" &           # run avida in the background
    sleep 2	
	sed -i "40s/data$CURR/data$NEXT/" avida.cfg # change data outputfile by 1
	((CURR=CURR+1))
done
wait
# reset data outputfile to 1
sed -i "40s/data$NEXT/data/" avida.cfg 
: '
#reset event file to 100000
sed -i "40s/$POPUPDATES/100000/" events.cfg 
sed -i "30s/$POPUPDATES/100000/" events.cfg 

#move data files into workantiadd labeled with which run
CURR=1
MOVED=1
while ((CURR<=POPCYCLES))       # number of times to run avida
do
	echo "got in loop"
	cd data$CURR
	#checking if instruction is actually in dominant
	grep -qi $SEARCHINSTR archive/*.org
	greprc=$?
	echo $greprc
	if [[ $greprc -eq 0 ]]; then
		cp detail-$POPUPDATES.spop ../../workantiadd/populations/detail-$POPUPDATES-$MOVED.spop
		((MOVED=MOVED+1))	
	elif [[ $greprc -eq 1 ]]; then
		echo "population $CURR doesn't have instruction in dominant"
	else
		echo "something went wrong with grep"
	fi

	cd ..
	((CURR=CURR+1))
done
wait


#this is how many got successfully moved
((MOVED=MOVED-1))
if [[ $MOVED -lt 1 ]]; then
	echo "No populations evolved instruction"
 	exit 1
 fi 

#prepare workantiadd to run multiple times
cd ../workantiadd
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

