.
├── aligning-orthonucleotides # needed for dNdS analyses
│   ├── aligning-orthogroups.txt
│   ├── aligning-orthonucleotides-longer-time.sh
│   └── aligning-orthonucleotides-subset.sh
├── analysing-crabro-rna # using Nextflow nfcore/rnaseq and DESeq2
│   ├── 2020-08-06-DGE.html
│   ├── 2020-08-06-DGE.Rmd
│   ├── myriad.config
│   ├── preparing-rna-samples.txt
│   └── WHATIDID.txt
├── analysing-genome-content # using quast, busco
│   ├── analysing-genome-content.txt
│   ├── busco-config.ini
│   ├── convert2csv.py
│   ├── extract_genome_stats.py
│   ├── quast-A_mellifera.sh
│   ├── requirements.txt
│   ├── run-busco-A_mellifera.sh
│   ├── VespaGenomeFigure1.R
│   └── VespaGenomesFigures.Rmd
├── calculating-dnds # using paml
│   ├── 2021-11-28-dnds-analysis.Rmd
│   ├── calculating-branch-dnds-V_crabro.sh
│   ├── calculating-branch-site-dnds-V_crabro.sh
│   ├── calculating-dnds.txt
│   ├── collect-data-from-branch-codeml.sh
│   └── tidy-apis-orthogroups-protein-names.R
├── comparative-analysis
│   ├── comparing-degs-dnds-duplication.Rmd
│   └── WHATIDID.txt
├── duplication-analysis # using OrthoFinder result
│   ├── 2021-08-21-gene-duplication-event-tree-figure.Rmd
│   ├── filter-blast.sh
│   └── gene-duplication-events-wrangling.txt
└── orthogroups-analysis # using blast, OrthoFinder
    ├── 2021-11-15-topgo.Rmd
    ├── blastp-V_crabro_against_fly.sh
    ├── blastp-V_crabro-deg-against-apis.sh
    ├── longest-isoform_A_mellifera.sh
    ├── longest-isoform_S_invicta.sh
    ├── longest-isoforms_P_canadensis.sh
    ├── longest-isoforms_P_dominula.sh
    ├── longest-isoform_V_crabro.sh
    ├── longest-isoform_V_germanica.sh
    ├── longest-isoform_V_mandarinia.sh
    ├── longest-isoform_V_pensylvanica.sh
    ├── longest-isoform_V_velutina.sh
    ├── longest-isoform_V_vulgaris.sh
    ├── make-orthogroup-fnas.sh
    ├── run-orthofinder.sh
    ├── subset-longest-protein-isoform.R
    ├── tidy-apis-orthogroups-protein-names.R
    └── vespa-interesting-orthogroup-analysis.txt
