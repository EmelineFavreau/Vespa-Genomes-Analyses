# This script uses the Dfam TE Tools container (version 1.7; https://github.com/Dfam-consortium/TETools)

# which includes the following versions of:
# RepeatModeler 2.0.4
# RepeatMasker 4.1.4

# also used:
# cd-hit 4.6.8
# bbmap 39.01

## setting up dfam-tetools
## need to open the container using:
singularity run docker://dfam/tetools:latest

# Make a copy of the original RepeatMasker Libraries/ directory here
cp -r /opt/RepeatMasker/Libraries/ ./

## update Dfam (using curated v3.7):
## ========================
wget https://www.dfam.org/releases/current/families/Dfam_curatedonly.h5.gz
# Overwrite the new Dfam.h5 file into Libraries/
cp Dfam_curatedonly.h5.gz Libraries/
# Update the file RepeatMaskerLib.h5 to the new Dfam.h5
ln -sf Dfam_curatedonly.h5.gz Libraries/RepeatMaskerLib.h5

## add RepBase RepeatMasker Edition:
## =============================================
# Extract RepBase RepeatMasker Edition (the .tar.gz file should unpack into Libraries/)
tar -x -f /work/path/to/RepBaseRepeatMaskerEdition-20181026.tar.gz
# Run the addRepBase.pl script (part of the RepeatMasker package) to merge the databases,
# specifying the new Libraries directory.
addRepBase.pl -libdir RepeatMasker/Libraries/

exit

## Now we are ready to run 
## First we run RepeatModeler for each genome

# Build database for each genome

singularity exec docker://dfam/tetools:latest BuildDatabase -name crabro vespa/crabro.fa

singularity exec docker://dfam/tetools:latest BuildDatabase -name velutina vespa/velutina.fa

# run RepeatModeler

cd crabro
singularity exec docker://dfam/tetools:latest RepeatModeler -database crabro -engine ncbi -threads 56 -LTRStruct > crabro_run.out

cd velutina
singularity exec docker://dfam/tetools:latest RepeatModeler -database velutina -engine ncbi -threads 56 -LTRStruct > velutina_run.out

# reduce redundancy of resulting libraries 

cd-hit-est -i crabro-families.fa -o crabro-reduced-families.fa -aS 0.8 -c 0.8 -G 0 -g 1 -d 0 -aS 0.8 -c 0.8 -G 0 -g 1 -b 500 -r 1 -T 32 -M 2000

cd-hit-est -i velutina-families.fa -o velutina-reduced-families.fa -aS 0.8 -c 0.8 -G 0 -g 1 -d 0 -aS 0.8 -c 0.8 -G 0 -g 1 -b 500 -r 1 -T 32 -M 2000

# filter out small consensi <100 bp
# used bbmap v39.01 reformat.sh script

bbmap/reformat.sh in=crabro-reduced-families.fa out=crabro-reduced-filtered-families.fa minlength=100

bbmap/reformat.sh in=velutina-reduced-families.fa out=velutina-reduced-filtered-families.fa minlength=100

## Now we run RepeatMasker using the cleaned up consensi

export LIBDIR=Libraries/
singularity exec docker://dfam/tetools:latest RepeatMasker -a -s -gff -no_is -lib crabro-reduced-filtered-families.fa -pa 32 -dir crabro_rm2 vespa/crabro.fa &> crab_rm2.run.out

export LIBDIR=Libraries/
singularity exec docker://dfam/tetools:latest RepeatMasker -a -s -gff -no_is -lib 
velutina-reduced-filtered-families.fa -pa 32 -dir velutina_rm2 vespa/velutina.fa &> vel_rm2.run.out

## extract divergence estimates

cd crabro_rm2/
singularity exec docker://dfam/tetools:latest calcDivergenceFromAlign.pl -s crabro.divsum crabro.fa.align
tail -n 72 crabro.divsum > crabro_R.txt

cd ../velutina_rm2/
singularity exec docker://dfam/tetools:latest calcDivergenceFromAlign.pl -s velutina.divsum velutina.fa.align
tail -n 72 velutina.divsum > velutina_R.txt

## took outputs and plotted in R -- see Rmd