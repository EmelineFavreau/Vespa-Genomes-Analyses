#$ -S /bin/bash
# Batch script to run a serial array job under SGE

# Request 5 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=5:0:0

# Request multi-threaded job
#$ -pe smp 8

# enable resource reservation
#$ -R y

# Request RAM
#$ -l tmem=10G
#$ -l h_vmem=10G

# Set the name of the job
#$ -N blastpdegcrabro

# put error messages in the log directory
#$ -e logs/$JOB_NAME

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

# balst against Apis, to obtain biological definitions
/share/apps/genomics/blast-2.10.0+/bin/blastp -query /SAN/ugi/VespaCrabro/input/analysing-crabro-rna/V_crabro-up_and_downregulated.faa \
        -db /SAN/ugi/VespaCrabro/input/proteins/A_mellifera.faa \
        -out /SAN/ugi/VespaCrabro/tmp/analysing-crabro-rna/deg \
        -max_target_seqs 1 \
        -outfmt 6 \
        -num_threads 8
