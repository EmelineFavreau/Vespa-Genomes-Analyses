#!/bin/bash
#$ -pe smp 2 # request 2 cores
#$ -l h_vmem=5G
#$ -l tmem=5G
#$ -l h_rt=6:00:00 
#$ -j y


# for each orthogroup, filter nucleotide fasta file for just those ortho-genes

export PATH=/share/apps/genomics/cufflinks-2.2.1/bin:$PATH
export PATH=/share/apps/genomics/seqtk:$PATH
export PATH=/share/apps/genomics/samtools-1.9/bin:$PATH

# inputs are:
# tmp/orthogroups-list-Genus_species-protein-id-list
# input/gff/Genus_species.gff.gz
# input/genomes/Genus_species.fna

cd VespaCrabro

# where the loop happens, for each orthgroup
while read -r orthogroup; do

	# create one orthogroup.fna
	rm --force tmp/${orthogroup}-*-transcripts-longest.fa
	rm --force tmp/${orthogroup}.fna
	rm --force input/orthogroup_fnas/${orthogroup}.fna
	rm --force input/orthogroup_fnas/${orthogroup}.singleline.fna
	touch input/orthogroup_fnas/${orthogroup}.fna

	while read -r GenusSpecies; do
	
		rm --force tmp/${orthogroup}-${GenusSpecies}-protein-id
		rm --force tmp/${orthogroup}-${GenusSpecies}.gff
		rm --force tmp/${orthogroup}-${GenusSpecies}-transcripts.fa 
		rm --force tmp/${orthogroup}-${GenusSpecies}-transcripts-longest.fa
		rm --force tmp/${orthogroup}-${GenusSpecies}-transcripts.fa.fai

		# grep that ortho protein id from the id file:
		grep "${orthogroup}" tmp/orthogroups-list-${GenusSpecies}-protein-id-list | cut -f 2 > tmp/${orthogroup}-${GenusSpecies}-protein-id

		# subset the gff for just this ortho protein
		zcat input/gff/${GenusSpecies}.gff.gz | grep --file tmp/${orthogroup}-${GenusSpecies}-protein-id > tmp/${orthogroup}-${GenusSpecies}.gff

		# filter the nucleotide fasta for the ortho protein sequence
		gffread /SAN/ugi/VespaCrabro/tmp/${orthogroup}-${GenusSpecies}.gff -M -W -x /SAN/ugi/VespaCrabro/tmp/${orthogroup}-${GenusSpecies}-transcripts.fa -g /SAN/ugi/VespaCrabro/input/genomes/${GenusSpecies}.fasta

		# shorten the header
		sed --in-place "s/ .*//g" tmp/${orthogroup}-${GenusSpecies}-transcripts.fa

		# obtain name of header for the longest sequence
		longSeqName=`seqtk comp tmp/${orthogroup}-${GenusSpecies}-transcripts.fa | sort -k2 | tail -n 1 | cut -f 1`

		# keep only the longest sequence
		samtools faidx tmp/${orthogroup}-${GenusSpecies}-transcripts.fa ${longSeqName} > tmp/${orthogroup}-${GenusSpecies}-transcripts-longest.fa
		
		# add species name to sequences
		# Use double quotes to make the shell expand :	variables while preserving whitespace
		sed --in-place "s/>.*$/>${GenusSpecies}/g" tmp/${orthogroup}-${GenusSpecies}-transcripts-longest.fa

		echo "${GenusSpecies} done"
	
	done<vespid_list

	# combine all sequences for this orthogroup (6 species)
	cat tmp/${orthogroup}-*-transcripts-longest.fa >> tmp/${orthogroup}.fna
	
	# transform interleaved fasta into single line fasta
	awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' tmp/${orthogroup}.fna > tmp/${orthogroup}.singleline.fna
	
	# ticker
	echo "${orthogroup} done"
	

done<tmp/single-copy-orthogroups-list

