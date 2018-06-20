sh runAvida.sh 
ls
vim runAvida.sh 
sh runAvida.sh 
ls
rm Data2.out
vim runAvida.sh 
sbatch runAvida.sh 
squeue -u hpc4256
ls
vim slurm-1471565.out 
vim runAvida.sh 
sbatch runAvida.sh 
squeue -u hpc4256
ls
vim slurm-1471584.out 
ls -a
l -a
ls -l
du -h
man ls
man ls -S
ls -s
ls -S
vim runAvida.sh 
sbatch runAvida.sh 
squeue -u hpc4256
ls
vim slurm-1471591.out 
vim runAvida.sh 
sbatch runAvida.sh 
squeue -u hpc4256
ls
vim slurm-1471594.out 
vim runAvida.sh 
rm slurm-*
ls
sbatch runAvida.sh 
squeue -u hpc4256
ls
vim slurm-1471650_1.out 
vim slurm-1471650_2.out 
cd data_1/
ls
rm *
ls
cd ..
data_2
cd data_2
ls
rm *
ls
cd ..
cd dat_3
cd data_3
ls
rm *
ls
cd ..
ls
cd data_4
ls
rm *
cd ..
sbatch runAvida.sh 
squeue -u hpc4256
sbatch runAvida.sh 
scancel 1471660
squeue -u hpc4256
ls
rm slurm -*
rm slurm-*
ls
data_1
cd data_1
ls
cd ..
cd data_2
ls
cd ..
vim avida.cfg
rm avida.cfg 
cp original_avida.cfg avida.cfg
ls
rm -R data_5
rm -R data_*
ls
cd avida.cfg
vim avida.cfg 
sbatch runAvida.sh 
squeue -u 4256
squeue -u hpc4256
ls
vim slurm-1471667_1.out 
vim slurm-1471667_2.out 
cd data_1
ls
cd ..
vim runAvida.sh 
sbatch runAvida.sh 
squeue -u hpc4256
ls
cd data_1
ls
cd ..
cd data_2
cd data_4
ls
cd ..
ls
vim slurm-1471673_1
vim slurm-1471673_1.out 
vim slurm-1471673_2.out 
vim runAvida.sh 
cd cbuild/
ls
cd work
ls
cd data
ls
cd ..
vim avida.cfg
./avida-viewer 
vim avida.cfg 
vim events.cfg 
vim instset-heads
vim instset-heads.cfg 
cd
cd avida-core/source/cpu/
vim cHardwareCPU.cc
ls
cd
ls
git fetch origin testingInstr
ls
git branch
git checkout testingInstr
git branch -a
git update
git checkout testingInstr
git fetch
git branch -a
git checkout testingInstr
git status
git branch
git add .
git add ./*
git status
git stash
git status
git checkout testingInstr 
git branch
ls
cd cbuild/
ls
cd ..
cd avida-core/source/cpu/
ls
vim cHardwareCPU.cc
cd
./build_avida 
ls
cd cbuild/
cd work
ls
vim avida.cfg 
cd ..
cp work workORN
cp -R work workORN
cp -R work workANDN
cp -R work workOR
ls
cd workANDN
ls
vim environment.cfg 
cd ..
cd workOR
vim environment.cfg 
vim events.cfg 
cd ..
workORN
cd workORN
vim environment.cfg 
vim events.cfg 
cd ../workANDN/
vim events.cfg 
cd
vim runAnti.sh 
mv runAnti.sh runAntiANDN.sh 
vim runAntiANDN.sh 
cp runAntiANDN.sh runAntiORN.sh 
cp runAntiANDN.sh runAntiOR.sh 
vim runAntiOR.sh 
vim runAntiORN.sh 
sbatch runAntiORN.sh 
sbatch runAntiOR.sh 
sbatch runAntiANDN.sh 
cd cbuild/
running
cd workORN
ls
cd logfile1
vim logfile1
vim logfile2
cd ../workOR
ls
vim logfile1
vim logfile2
cd ../workANDN
vim logfile1
vim logfile2
running
ls
cd cbuild/
ls
cd workANDN
ls
vim logfile1
workOR
work OR
ls
cd ../workOR
vim logfile1
vim logfile2
cd data1
ls
vim tasks.dat 
cd ../daat2
cd ../data2
vim tasks.dat 
cd ..
cd workANDN/
cd data1
vim tasks.dat 
vim ../data2/tasks.dat 
cd ..
ls
cd workORN
cd data1
vim tasks.dat 
vim ../data2/tasks.dat 
cd ..
ls
cd workOR
ls
vim avida.cfg 
vim events.cfg 
vim environment.cfg 
cd ..
ls
sbatch runAntiOR.sh 
running
ls
cd cbuild
ls
cd workOR
ls
cd
vim .gitignore
git push origin testingInstr 
git pull origin
cd cbuild/
ls
cd ..
git push origin testingInstr 
git pull
git add .
git commit -m "ORN and ANDN completed"
status
git add .
git add --all
git status
git commit -m "ANDN and ORN completed"
git config --global user.email "16sek@queensu.ca"
git config --global user.name "Spencer Kelly"
git status
git commit -m "ANDN and ORN completed"
git status 
git pull origin testingInstr 
git push origin testingInstr 
git pull
cd cbuild/
mv work/ workDefault/
ls
cd
git pull
vim .gitignore
git pull
git pull origin testingInstr 
cd cbuild/
ls
cd workEQU/
ls
cd
git add --all
git commit -m "commit with my stuff and Katy's stuff"
git pull
git push origin testingInstr 
cd cbuild/
cd workOR
ls
vim logfile1
cd ..
cd workOR
ls
cd data1
ls
vim tasks.dat 
cd ../data2/
ls
vim tasks.dat 
cd 
ls
vim setup.sh
array=(3 4 5)
array
$array
%array
$array[0]
$array[1]
echo $array
echo $array[1]
echo ${array[2]}
echo ${array[1]}
vim setup.sh 
echo $array
echo ${array}
echo ${array[]}
echo ${array[*]}
for i in ${array[*]} echo hello; 
for i in ${array[*]} ; echo hello
for i in ${array[*]}; do echo hello; done
for i in ${array[*]}; do echo hello $i; done
squeue
for i in ${array[*]}; do echo hello; done
vim setup.sh 
cd cbuild/work
vim avida.cfg 
cd
ls
vim runAntiANDN.sh 
vim setup.sh 
vim runAntiANDN.sh 
vim setup.sh 
vim runAntiANDN.sh 
vim setup.sh 
cd cbuild/work
ls
vim environment.cfg 
cd ..
vim setup.sh 
CNTR=2
CNTR
echo CNTR
echo $CNTR
f=1+$CNTR
echo $f
f=$(1+CNTR)
f=$((1+CNTR))
echo f
echo $f
vim setup.sh 
echo $f
echo $(f)
echo ${f}
echo ${f}hello
echo $fhello
vim setup.sh 
git add setup.sh
git status
git commit -m "setup"
git push origin testingInstr 
git pull
git push origin testingInstr 
vim setup.sh 
vim testLine
sed '1s/^/#/' testLine 
sed -i "3s/again/notagain/" testLine 
vim testLine 
sed -i '1s/^/#/' testLine 
vim testLine 
vim setup.sh 
sed -i "1s/^/#/" testLine 
vim testLine 
vim setup.sh 
git add setup.sh
git commit -m "setup complete"
git push origin testingInstr 
git pull
git push origin testingInstr 
logout
ls
cd cbuild/
ls
cd workOR
ls
cd data1
vim tasks.dat 
vim ../data2/tasks.dat 
vim ../data1/tasks.dat 
vim ../data2/tasks.dat 
cd
git pull origin testingInstr 
vim setup.sh 
cd cbuild/
cd work
ls
:q
cd
./build_avida 
cd cbuild/
cd work
mv work workNop-A20
ls
cd ..
mv work workNop-A20
ls
cd 
vim setup.sh 
sh setup.sh 
cd cbuild/
ls
cd workNop-A20/
ls
cd run
ls
mv * ..
ls
cd ..
ls
rm -R run
vim avida
vim avida.cfg 
vim events.cfg 
cd
vim setup.sh 
cp lib lib2
cp -R lib lib2
ls
cp libs lib2
ls
cp -R libs lib2
vim setup.sh 
sh setup.sh 
vim setup.sh 
cd cbuild/
ls
cd workNop-A20/
ls
rm -R run*
ls
cd 
vim setup.sh 
sh setup.sh 
vim setup.sh 
cd cbuild/
ls
cd workNop-A20/
ls
runANDN
cd runANDN/
ls
vim environment.cfg 
vim events.cfg 
vim avida.cfg 
cd ..
ls
cd runANDN/
mv * ..
ls
cd ..
ls
rm -R run*
ls
cd 
vim setup.sh 
sh setup.sh 
cd cbuild/
ls
cd workNop-A20/
ls
cd runANDN/
ls
vim environment.cfg 
vim events.cfg 
vim avida.cfg 
vim ../runORN/environment.cfg 
vim ../runORN/events.cfg 
cd
vim setup.sh 
cd cbuild/workNop-A20/
ls
cd runANDN
mv * ..
ls
cd ..
ls
rm -R run*
ls
cd avida.
vim avida.cfg 
vim environment.cfg 
ls
cd
cd cbuild/
cp workNop-A20/ workNop-A40
cp -R workNop-A20/ workNop-A40
ls
cd
ls
vim setup.sh 
sh setup.sh 
cd cbuild
cd workNop-A
cd workNop-A20/
ls
vim runANDN/events.cfg 
vim runANDN/environment.cfg 
vim runORN/environment.cfg 
cd ..
cd workNop-A40/
ls
cd runEQU
ls
vim events.cfg 
cd ..
vim setup.sh 
cd cbuild/
ls
cd workNop-A20
ls'
ls
cd runANDN
ls
./avida
vim events.cfg 
./avida
:q
vim events.cfg 
cd
cd cbuild/workANDN/
ls
cd data1
ls
vim tasks.dat 
cd ..
cd data2
vim tasks.dat 
cd ..
rm -R data2
ls
mv -R data1 data
mv data1 data
ls
cd data
ls
mv detail-10000.spop 
mv detail-10000.spop detail.spop
ls
cd ../..
cd workOR
ls
cd data1
ls
vim tasks.dat 
cd ../data2
vim tasks.dat 
cd ..
ls
rm -R data2
mv data1 data
ls
cd data
ls
mv detail-10000.spop detail.spop
ls
cd ..
cd workORN
cd data1
ls
vim tasks.dat 
cd ..
cd data2
vim tasks.dat 
cd ..
rm -R data2
mv data1 data
cd data
ls
mv detail-10000.spop detail.spop
ls
cd ..
cd workNop-A20
cd runANDN
ls
vim events.cfg 
./avida
vim events.cfg 
./avida
cd
ls
rm runAnti*
ls
git add --all
git status
:q
cd cbuild
ls
rm -R workNop-A*
cd
git reset HEAd
git reset HEAD
git add --all
git commit -m "complete setup.sh"
git push origin testingInstr 
vim testing
mv testing testss.sh
vim testss.sh 
cd cbuild/
ls
mkdir work
ls
cd ..
sh testss.sh 
cd cbuild
ls
rm -R workdfsf*
ls
rm -R workdsf*
ls
rm -R workffd*
ls
rm -R workNop*
ls
cd ..
vim testss.sh 
sh testss.sh 
cd cbuild/
ls
rm -R workNop*
ls
cd ..
ls
rm -R lib2/
vim testss.sh 
sh testss.sh 
vim testss.sh 
sh testss.sh 
:q
cd cbuild/
ls
:q
cd
vim testss.sh 
sh testss.sh 
:q
vim testss.sh 
sh testss.sh 
vim testss.sh 
sh testss.sh 
vim testss.sh 
sh testss.sh
array=(1 2 3 4)
for i in ${array[@]}; do for j in ${array[@]}; do  echo $i $j; done; done
a=(nop for)
for i in ${a[@]}; do for j in ${array[@]}; do  echo $i $j; done; done
ls
rm testLine
vim testss.sh 
sh testss.sh 
vim testss.sh 
ls
rm testss.sh
vim setup.sh 
ls
cd cbuild/
ls
rm -R work{20,40,60}
ls
rm -
rm -R work80
rm -R workNop*
ls
rm -R workswap*
ls
cd ..
ls
git pull origin testingInstr 
ls
vim changeConcentration.sh 
sh changeConcentration.sh 
ls
cd cbuild/
ls
cd ..
vim changeConcentration.sh 
sh changeConcentration.sh 
vim avida-core/source/cpu/cHardwareCPU.cc 
cd
ls
cd cbuild
ks
ls
cd workO
cd work0
ls
cd ..
rm work0
rm -R work0
ls
cd ..
ls
vim avida-core/source/cpu/cHardwareCPU.cc 
sh changeConcentration.sh 
cd cbuild/
ls
cd work0
ls
cd ..
ls
cd ..
vim setup.sh 
vim changeConcentration.sh 
sh changeConcentration.sh 
cd cbuild/
ls
cd workSet-Flow20/
ls
cd
cd cbuild/
rm work0
rm -R work0
rm -R workSet-Flow20/
ls
cd ..
ls
vim multi.sh 
vim submission.sh
vim setup.sh 
vim submission.sh
vim setup.sh 
vim multi.sh 
vim submission.sh 
cd ..
cd 
cd cbuild/
ls
cd ..
sh changeConcentration.sh 
vim submission.sh 
cd cbuild/
ls
cd ..
ls
sh submission.sh 
vim submission.sh 
vim multi.sh 
sh submission.sh 
vim multi.sh 
sh submission.sh 
ls
cd
cd cbuild/
ls
cd ..
cd
ls
vim submission.sh 
./submission
sh submission.sh 
./multi.sh 
vim multi.sh 
vim v.sh
ls
rm v.sh 
ls
vim logfile
rm logfile*
ls
run submission.sh 
job submission.sh 
sjob submission.sh 
sh submission.sh 
chmod u+x submission.sh 
ls
./submission.sh 
vim submission.sh 
git add submission.sh
git commit -m "submissions script"
git push origin testingInstr 
git pull
git add --all
git commit -m "submission"
git pull
git pull origin testingInstr 
git push origin testingInstr 
git pull
vim changeConcentration.sh 
vim multi.sh 
vim setup.sh 
git pull
git pull origin testingInstr 
git add .
git commit -m "submission"
git config --global user.email "16sek@queensu.ca"
git config --global user.name "Spencer Kelly"
ls
git push origin testingInstr 
git pull
git pull origin testingInstr 
git status
git commit -m "submission"
git push origin testingInstr 
ls
./submission.sh 
sh submission.sh 
vim submission.sh 
sh submission.sh 
./submission.sh 
vim submission.sh 
./submission.sh 
sh submission.sh 
vim submission.sh 
sh submission.sh 
vim multi.sh 
sh submission.sh 
vim multi.sh 
vim submission.sh 
sh submission.sh 
vim submission.sh 
sh submission.sh 
vim multi.sh 
cd cbuild/
ls
cd workSet-Flow20/
ls
vim logfile1
rm logfile*
ls
cd
sh submission.sh 
cd cbuild/workSet-Flow20/
ls
cd
ls
vim multi.sh 
cd cbuild/workSet-Flow20/
ls
rm logfile*
ls
cd
vim submission.sh 
sh submission.sh 
cd cbuild/
cd workSet-Flow20/
ls
vim logfile1
cd
cd cbuild/workSet-Flow20/
ls
vim events.cfg 
vim logfile1
jobs
cd
jobs
kill
ps
kill 74014
ps
kill 740*
kill 74017
kill 74056
kill 74077
ls
ps
kill 74107
kill 74126
ps
ls
cd cbuild/
ls
cd workSet-Flow20/
ls
rm -R data*
ls
rm logfile*
ls
cd
ls
vim multi.sh 
cd
cd cbuild/
ls
cd workSet-Flow20/
vim avida
vim avida.cfg 
cd
cd cbuild/workSet-Flow20/
ls
vim events.cfg 
cd
ls
sh submission.sh 
ps
vim changeConcentration.sh 
git status
git add submission.sh
git add multi.sh
git commit -m "final submission and multi"
git push origin testingInstr 
cd
vim setup.sh 
cd
cd cbuild
ls
rm -R workSet-Flow20/
ls
cd ..
ls
sbatch setup.sh 
vim multi.sh 
vim setup.sh 
sbatch setup.sh 
ls
;s
ls
vim slurm-1578063.out 
running
vim slurm-1578063.out 
cd cbuild/u
cd cbuild/
ls
scancel 1578063
cd ..
ls
vim setup.sh 
vim submission.sh 
vim changeConcentration.sh 
vim setup.sh 
rm slurm-1578063.out 
ls
vim setup.sh 
sbatch setup.sh 
vim slurm-1578120.out 
cd cbuild/
ls
scancel 1578120
cd
vim changeConcentration.sh 
vim avida-core/source/cpu/cHardwareCPU.cc 
vim changeConcentration.sh 
vim avida-core/source/cpu/cHardwareCPU.cc 
vim changeConcentration.sh 
vim setup.sh 
cd cbuild/
ls
rm -R workIf*
ls
rm -R workNop*
ls
cd
sbatch setup.sh 
cd cbuild/
ls
cd
vim slurm-1578
vim slurm-1578267.out 
cd cbuild/
ls
cd
ls
cd cbu
cd cbuild
cd ..
ls
cd
ls
cd run
ls
cd ..
cd runOR
ls
logout
ls
cd
cd global/
ls
cd ..
cd home
ls
cd ..
cd run
ls
cd ..
cd usr
ls
cd ..
cd mnt
ls
logout
