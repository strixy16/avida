CONCENTRATION=20 #default concentration, can just change number here

#setting concentration
cd avida-core/source/cpu #get to directory with cHardwareCPU
sed "2965s/20/$CONCENTRATION/" cHardwareCPU.cc > temp
cat temp > cHardwareCPU.cc
rm temp

cd ../../.. #get back into avida
./build_avida #compiles new concentration

#setting it up to run the way runAnti.sh can accept
cd cbuild
mv work workantiadd

cd workantiadd
mkdir populations #folder to hold populations that can be loaded

#make default copy mutation 0.0025
sed "49s/0.0075/0.0025/" avida.cfg > temp
cat temp > avida.cfg
rm temp

#load population line instead of inject
sed "17s/Inject default-heads.org/LoadPopulation populations/detail.spop/" events.cfg > temp
cat temp > events.cfg
rm temp


#so next time run this it works
cd ../../avida-core/source/cpu #get to directory with cHardwareCPU
sed "2965s/$CONCENTRATION/20/" cHardwareCPU.cc > temp
cat temp > cHardwareCPU.cc
rm temp