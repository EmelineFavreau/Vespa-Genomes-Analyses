#$ -S /bin/bash

# Batch script to run a serial array job under SGE

# Request ten minutes of wallclock time (format hours:minutes:seconds).
# one job ran on frontend was 60 seconds
#$ -l h_rt=1:0:0

# Request RAM
# /usr/bin/time --verbose prank gave Maximum resident set size (kbytes): 4656
#$ -l tmem=2G
#$ -l h_vmem=2G

# Set up the job array
# wc -l /SAN/ugi/VespaCrabro/tmp/single-copy-orthogroups-list-subset
#$ -t 1-10

# Set the name of the job
#$ -N PrankVespaSubset

# Set the standard error and output combined
#$ -j y

#$ -o logs/$JOB_NAME/$JOB_ID/

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

orthogroup_name=$(sed -n "${SGE_TASK_ID}p" /SAN/ugi/VespaCrabro/tmp/single-copy-orthogroups-list-subset)


# Run the application

#echo "$JOB_NAME $SGE_TASK_ID"

/SAN/ugi/VespaCrabro/tools/wasabi/binaries/prank/prank -d=/SAN/ugi/VespaCrabro/tmp/${orthogroup_name}.singleline.fna -o=/SAN/ugi/VespaCrabro/result/aligning-orthonucleotides/${orthogroup_name}-prank_output_file -f=paml -F -codon
