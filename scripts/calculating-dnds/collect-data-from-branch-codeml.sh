#$ -S /bin/bash

# Batch script to obtain dnds values for each orthogroup

# Request 20 minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:0:0

# Request RAM (must be an integer followed by M, G, or T)
# /usr/bin/time --verbose codeml gave Maximum resident set size (kbytes): 2276
#$ -l tmem=5G
#$ -l h_vmem=5G

# Set up the job array.
# wc -l tmp/aligned-orthogroups-2021-09-09
#$ -t 1-2685

# Set the name of the job
#$ -N collectdNdSVespaBranch

# put error messages and outpout in the log directory
#$ -e logs/$JOB_NAME
#$ -o logs/$JOB_NAME

# set the orthogroup at start of array
orthogroup=$(sed -n "${SGE_TASK_ID}p" /SAN/ugi/VespaCrabro/tmp/aligned-orthogroups-2021-09-09)

# set tmp
export TMPDIR=/SAN/ugi/VespaCrabro/tmp

# set species
species="V_crabro"

# remove previous result file
rm -rf /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/${orthogroup}-codeml-result-table

# start a new result file
echo -e "orthogroup\tw_M0\tnp_M0\tlnL_M0\tnp_M2\tlnL_M2\tbackground_w\tforeground_w\tkappa_M2\tD\tDF\tchiTest" > /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/${orthogroup}-codeml-result-table

# collect variables /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M0-${orthogroup} 
# obtain omega, number of parameters, log-likelihood

w_M0=`grep "omega" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M0-${orthogroup} | sed "s/ //g" | cut -d "=" -f 2`

np_M0=`grep "lnL" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M0-${orthogroup} | sed "s/ //g" | cut -d ")" -f 1 | cut -d ":" -f 3`

lnL_M0=`grep "lnL" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M0-${orthogroup} | sed "s/ //g"  | cut -d "+" -f 1 | cut -d ":" -f 4`

np_M2=`grep "lnL" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M2-${orthogroup} | sed "s/ //g" | cut -d ")" -f 1 | cut -d ":" -f 3`

lnL_M2=`grep "lnL" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M2-${orthogroup} | sed "s/ //g"  | cut -d "+" -f 1 | cut -d ":" -f 4`

# - the omega and kappa values:
# the first omega is for branch #0, the background
background_w=`grep "w (dN/dS) for branches" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M2-${orthogroup} | cut -d " " -f 6`

# the second omega is for branch #1, the foreground
foreground_w=`grep "w (dN/dS) for branches" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M2-${orthogroup} | cut -d ":" -f 2 | sed "s/ //g"`

kappa_M2=`grep "kappa" /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/M2-${orthogroup} | cut -d " " -f 5`

# D = 2(nLL_0 - nLL)
D=`echo "2*($lnL_M2 - $lnL_M0)" | bc`

DF=`echo "$np_M2 - $np_M0" | bc`

chiTest=`/SAN/ugi/VespaCrabro/tools/paml4.9j/bin/chi2 $DF $D | cut -d " " -f 8 -s`


# collect all info for this round and save it in result/omega_results
# w_M0 np_M0 lnL_M0 np_M2 lnL_M2 background_w foreground_w kappaM1 TestStatistic DF chiTest
echo -e "${orthogroup}\t$w_M0\t$np_M0\t$lnL_M0\t$np_M2\t$lnL_M2\t$background_w\t$foreground_w\t$kappa_M2\t$D\t$DF\t$chiTest" >> /SAN/ugi/VespaCrabro/result/calculating-dnds/branch-model/${species}/${orthogroup}-codeml-result-table
