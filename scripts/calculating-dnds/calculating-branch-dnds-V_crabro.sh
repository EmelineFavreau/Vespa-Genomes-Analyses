#$ -S /bin/bash

# Batch script to calculate dnds for each orthogroup focuing on one species

# Request 20 minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:20:0

# Request RAM (must be an integer followed by M, G, or T)
# /usr/bin/time --verbose codeml gave Maximum resident set size (kbytes): 2276
#$ -l tmem=2G
#$ -l h_vmem=2G

# Set up the job array.
# wc -l tmp/aligned-orthogroups-2021-09-09
#$ -t 1-2685

# Set the name of the job
#$ -N CodemlVespaBranch

# put error messages and outpout in the log directory
#$ -e logs/$JOB_NAME
#$ -o logs/$JOB_NAME

# set the orthogroup at start of array
orthogroup=$(sed -n "${SGE_TASK_ID}p" /SAN/ugi/VespaCrabro/tmp/aligned-orthogroups-2021-09-09)

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

# V_crabro is foreground in model 2
species="V_crabro"

# create directories for templates and resulting files
mkdir -p /SAN/ugi/VespaCrabro/input/config-files/${species}/
mkdir -p /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/

# create config file for null model (m0, dn/ds ratio without variable between lineages)
cp /SAN/ugi/VespaCrabro/input/config-files/template_M0.ctl /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M0.ctl

# update the orthogroup name
sed --in-place "s/OG/${orthogroup}/g" /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M0.ctl

# update the species name
sed --in-place "s/species/${species}/g" /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M0.ctl

# run algorithm for model 0 (need full path of config file)
/SAN/ugi/VespaCrabro/tools/paml4.9j/bin/codeml /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M0.ctl

# create config file for model 2 (m2, dn/ds ratio with the species in foreground branch)
cp /SAN/ugi/VespaCrabro/input/config-files/${species}-template_M2.ctl /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M2.ctl

# update the orthogroup name
sed --in-place "s/OG/${orthogroup}/g" /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M2.ctl

# update the species name
sed --in-place "s/species/${species}/g" /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M2.ctl

# run algorithm for model 2 (tree species if different)
/SAN/ugi/VespaCrabro/tools/paml4.9j/bin/codeml /SAN/ugi/VespaCrabro/input/config-files/${species}/${orthogroup}_M2.ctl

