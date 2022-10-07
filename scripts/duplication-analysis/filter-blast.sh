#!/bin/bash -l
for species in V_crabro V_velutina; do
	echo "orthogroup" tmp/${species}-orthogroup-to-paste-in-blast-results

	for protein in $(cut -f 1 result/duplication-analysis/${species}-blast-result-filtered); do
		grep $protein result/orthogroups-analysis/Results_Aug12_1/Gene_Duplication_Events/Duplications.tsv | cut -d 1 >> tmp/${species}-orthogroup-to-paste-in-blast-results
	done

	paste tmp/${species}-orthogroup-to-paste-in-blast-results result/duplication-analysis/${species}-blast-result-filtered > result/duplication-analysis/${species}-blast-result-filtered-with-orthogroups
done
