#$ -S /bin/bash
# Batch script to run a serial array job under SGE

# Request one hour of wallclock time (format hours:minutes:seconds).
# one job ran on myriad was set at 5h
#$ -l h_rt=5:0:0

# Request multi-threaded job
#$ -pe smp 8

# enable resource reservation
#$ -R y

# Request RAM
#$ -l tmem=10G
#$ -l h_vmem=10G

# Set the name of the job
#$ -N blastpcrabro

# put error messages in the log directory
#$ -e logs/$JOB_NAME

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

# set species
species="V_crabro"

/share/apps/genomics/blast-2.10.0+/bin/blastp -query /SAN/ugi/VespaCrabro/input/proteins/${species}-short-name.faa \
        -db /SAN/ugi/VespaCrabro/input/proteins/D_melanogaster.faa \
        -out /SAN/ugi/VespaCrabro/tmp/ortho-enrichment/result/${species} \
        -max_target_seqs 1 \
        -outfmt 6 \
        -num_threads 8
