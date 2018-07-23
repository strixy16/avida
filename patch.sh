#!/bin/bash

#SBATCH -c 1
#SBATCH --mem=3072
#SBATCH --time=0-1:0:00

source ./variables.sh

#create empty list for each incomplete run
RERUN=()


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
                    cd nomutdata$i
                    lastLine=$(tail -1 tasks.dat)
                    UPDATE=$(cut -d " " -f1 <<< $lastLine)
                    NUMORG=$(cut -d " " -f2 <<< $lastLine)

                    if [[ $NUMORG -eq 3600 ]]; then #this assumes population of 3600, will need to change if not true
                        if [[ $UPDATE -ne $POPUPDATES ]]; then
                            #need a patch, run got cut off early rather than dying out
                            RERUN+=("$RXN $INSTR$CONC nomutdata$i") #add info to target incomplete run to array
                        fi
                    fi

                    cd ..
                done
            else
                ##this code will read the regular run
                for (( i = 1; i <= $RUNS; i++ )); do
                    cd data$i
                    lastLine=$(tail -1 tasks.dat)
                    UPDATE=$(cut -d " " -f1 <<< $lastLine)
                    NUMORG=$(cut -d " " -f2 <<< $lastLine)

                    if [[ $NUMORG -eq 3600 ]]; then #this assumes population of 3600, will need to change if not true
                        if [[ $UPDATE -ne $POPUPDATES ]]; then
                            #need a patch, run got cut off early rather than dying out
                            RERUN+=("$RXN $INSTR$CONC data$i") #add info to target incomplete run to array
                        fi
                    fi

                    cd ..  
                done
            fi
            cd ..
        done
        cd ..
    done
done


#submits single multi.sh runs to replace incomplete runs
for i in ${RERUN[@]}; do
    RUNFOLDER=$(cut -d " " -f1 <<< $i)
    WORKFOLDER=$(cut -d " " -f2 <<< $i)
    DATA==$(cut -d " " -f3 <<< $i)

    cd work$FOLDER/run$RXN
    rm -R $DATA

    #multi will create data1 so move conflict out of the way
    if [[ -f data1 ]]; then
        mv data1 temporarydatafolder
    fi

    cd ../..

    #goes into the right folder
    sed -i -E "s|cbuild/[[:alnum:]]*/*[[:alnum:]]*|cbuild/work$FOLDER/run$RXN|" multi.sh 
    #only runs once
    sed -i "/source \.\/variables/a RUNS=1" multi.sh
    sbatch multi.sh
    #back to neutral
    sed -i "s|cbuild/work$FOLDER/run$RXN|cbuild/work|" multi.sh
    #will run according to variables.sh
    sed -i "/RUNS=1/d" multi.sh

    cd work$FOLDER/run$RXN
    #puts the naming back to normal
    mv data1 $DATA
    if [[ -f temporarydatafolder ]]; then
        mv temporarydatafolder data1
    fi

done