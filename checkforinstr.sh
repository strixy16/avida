#!/bin/bash

SEARCHINSTR='add'	#instruction to search for

# make sure that PrintDominantGenotype is uncommented in events and prints just at the end
grep -qi $SEARCHINSTR cbuild/work/data/archive/*.org  
greprc=$?
if [[ $greprc -eq 0 ]] ; then
	# run avida the second time
	echo Found
else
	if [[ $greprc -eq 1 ]]; then
		echo add instruction not in dominant genome
		# run avida again from scratch to get add instruction
		exit 0
	else
		echo Some sort of error from grep
		exit 1
	fi
fi	

