#$ -S /bin/bash
# Batch script to run a serial array job under SGE

# Request one hour of wallclock time (format hours:minutes:seconds).
# one job ran on frontend was 60 seconds
#$ -l h_rt=2:0:0

# Request RAM
# /usr/bin/time --verbose prank gave Maximum resident set size (kbytes): 4656
#$ -l tmem=2G
#$ -l h_vmem=2G

# Set up the job array
# wc -l /SAN/ugi/VespaCrabro/tmp/need-longer-time-orthogroups-list
#$ -t 1-60

# Set the name of the job
#$ -N PrankVespa

# put error messages in the log directory
#$ -e logs/$JOB_NAME

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

orthogroup_name=$(sed -n "${SGE_TASK_ID}p" /SAN/ugi/VespaCrabro/tmp/need-longer-time-orthogroups-list)


# Run the application

#echo "$JOB_NAME $SGE_TASK_ID"

/SAN/ugi/VespaCrabro/tools/wasabi/binaries/prank/prank -d=/SAN/ugi/VespaCrabro/tmp/${orthogroup_name}.singleline.fna -o=/SAN/ugi/VespaCrabro/result/aligning-orthonucleotides/${orthogroup_name}-prank_output_file -f=paml -F -codon


