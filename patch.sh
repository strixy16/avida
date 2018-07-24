#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=3072
#SBATCH --time=0-1:0:00

source ./variables.sh

#create empty list for each incomplete run
RERUN=()

cd cbuild

#loop to create arrays with the incomplete data folders in it, each array a different reaction
for INSTR in ${aINSTR[@]} 
do
    for CONC in ${aCONC[@]}
    do
        cd work$INSTR$CONC

        for RXN in ${aRXNS[@]}
        do
            cd run$RXN

            if [[ $noMut == true ]]; then
                ##this code will read the noMut run
                for (( i = 1; i <= $RUNS; i++ )); do
                    #check if data folder exists
                    if [[ -d nomutdata$i ]]; then
                        cd nomutdata$i
                        #check if taskdata exists
                        if [[ -f tasks.dat ]]; then
                            lastLine=$(tail -1 tasks.dat)
                            UPDATE=$(cut -d " " -f1 <<< $lastLine)
                            NUMORG=$(cut -d " " -f2 <<< $lastLine)

                            if [[ $NUMORG -eq 3600 ]]; then #this assumes population of 3600, will need to change if not true
                                if [[ $UPDATE -ne $POPUPDATES ]]; then
                                    #need a patch, run got cut off early rather than dying out
                                    RERUN+=("$RXN+$INSTR$CONC+nomutdata$i") #add info to target incomplete run to array
                                fi
                            fi
                        else 
                            #if tasks.dat doesn't exist, it needs to be run
                            RERUN+=("$RXN+$INSTR$CONC+nomutdata$i") #add info to target incomplete run to array
                        fi

                        cd ..
                    else
                        #if data folder doesn't exist, it needs to be run
                       RERUN+=("$RXN+$INSTR$CONC+nomutdata$i") 
                    fi
                done
            else
                ##this code will read the regular run
                for (( i = 1; i <= $RUNS; i++ )); do
                    cd data$i
                    if [[ -f tasks.dat ]]; then
                        lastLine=$(tail -1 tasks.dat)
                        UPDATE=$(cut -d " " -f1 <<< $lastLine)
                        NUMORG=$(cut -d " " -f2 <<< $lastLine)

                        if [[ $NUMORG -eq 3600 ]]; then #this assumes population of 3600, will need to change if not true
                            if [[ $UPDATE -ne $POPUPDATES ]]; then
                                #need a patch, run got cut off early rather than dying out
                                RERUN+=("$RXN+$INSTR$CONC+data$i") #add info to target incomplete run to array
                            fi
                        fi
                    else
                        #if tasks.dat doesn't exist, it needs to be run
                        RERUN+=("$RXN+$INSTR$CONC+nomutdata$i") #add info to target incomplete run to array
                    fi
  

                    cd ..  
                done
            fi
            cd ..
        done
        cd ..
    done
done

TEMPLIST=()
#copy of the first so it passes the test
OLDRUN=$(cut -d "+" -f1 <<< $RERUN)
OLDWORK=$(cut -d "+" -f2 <<< $RERUN)

# submits single multi.sh runs to replace incomplete runs
for i in ${RERUN[@]}; do
    RUNFOLDER=$(cut -d "+" -f1 <<< $i)
    WORKFOLDER=$(cut -d "+" -f2 <<< $i)
    DATA=$(cut -d "+" -f3 <<< $i)

    #testing if they are in the same directory
    if [[ $OLDRUN == $RUNFOLDER ]] && [[ $OLDWORK == $WORKFOLDER ]]; then
        TEMPLIST+=($i)
        echo $TEMPLIST
    fi
    # cd work$WORKFOLDER/run$RUNFOLDER

    # #delete incomplete version if it exists
    # if [[ -d $DATA ]]; then
    #     rm -R $DATA
    # fi



    # cd ../../..



done
