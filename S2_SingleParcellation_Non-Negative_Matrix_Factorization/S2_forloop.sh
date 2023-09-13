#!/bin/bash
###for loop create .slurms

InitializationFolder='/home/cuizaixu_lab/liyaoxin/DATA/workdir/project/SingleParcellation/Initialization'
for i in `seq 1 50`
do
	file=./tmp/S2_${i}.slurm
	rm $file
	touch $file
	echo '#!/bin/bash' >> $file
	echo "#SBATCH --nodes=1 /# OpenMP requires a single node" >> $file
	echo "#SBATCH -p q_cn" >> $file
	echo "#SBATCH --ntasks=1 /# Run a single serial task" >> $file
	echo "#SBATCH --cpus-per-task=16" >> $file
	echo "#SBATCH --mem-per-cpu=8gb" >> $file
	echo "#SBATCH --time=50:00:00 /# Time limit hh:mm:ss" >> $file
	echo "#SBATCH -e log/%j_error.log /# Standard error" >> $file
	echo "#SBATCH -o log/%j_out.txt /# Standard output" >> $file
	echo "#SBATCH --job-name=gensrpts /# Descriptive job name" >> $file
	echo "#SBATCH --mail-user selinali@umich.edu" >> $file
	echo "#SBATCH --mail-type=END" >> $file
	echo "#" >> $file
	echo sh ${InitializationFolder}/tmp${i}.sh >> $file
done

### for loop submit batch jobs
# for i in `seq 1 50`; do sbatch tmp/S2_${i}.slurm; done
# taskid=; for i in `seq 2 10`; do $i+$taskids ; done