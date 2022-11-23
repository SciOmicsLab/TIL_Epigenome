# TIL Epigenome Paper

## Scripts for the paper analyzing RNA-seq, ChIP-seq for TIL Epigenomic data.

This repository contains
1. Code to reproduce the analyses and figures in "CD4 Polarization Phenotypes are Associated with Reduced Expansion of
Tumor Infiltrating Lymphocytes in Adoptive Cell Therapy Treated Melanoma Patients"
* Full-length dataset is available from Geo as accession number [GSE218006] (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE218006) 
* Pre-processed data sets such as count matrices and Sample metadata (de-identified) are also available in this Github.



## Materials & Methods: 
Clinical trials and patient samples
Females and Males are split equally between TIL Low and TIL High groups. 

### RNA-seq analysis
For RNA-seq libraries, reads were evaluated by FASTQC for sequence quality and adapter contamination. Reads displayed high quality without evidence of adapter contamination, thus reads were not trimmed. Reads were aligned to the human genome (GRCH38) using HISAT2 (v2.2.1). Mapped reads were counted using HTSeq ver 0.13.5 with the options for paired end reads aligned to "gene" feature type and "gene_id" idattr, non-stranded (appropriate for this genome). Differential gene expression tests were performed with DESeq2. Genes with cutoff values of ±0.58 log2 fold-change (log2FC) and adjusted P < 0.1 (Benjamini-Hochberg method) were considered differentially expressed. Pathway analysis was conducted with Quiagen Ingenuity Pathway Analysis (IPA). 

### Chromatin Immunoprecipitation sequencing (ChIP-seq) library preparation and sequencing
CD4+ and CD8+ were isolated from the TIL product from melanoma patients that either responded to TIL ACT or had progressive disease. 

### ChIP-seq analysis
For ChIP-seq libraries, reads were evaluated by FASTQC for sequence quality and adapter contamination. Reads were trimmed using Trim Galore!” and aligned to the human genome (NCBI GRCH38 p14) using bowtie 2 (v2.4.2) with the default settings. Multimapping and duplicate reads were removed with SAMtools and Picard tools. ChIP enrichment peaks were called using macs2 (v.2.2.7.1) with the setting “--broad”. Differential ChIP peaks were identified using the R package, DiffBind with the option “minOverlap=2, bScaleControl = True, bSubControl = True, bParallel=True, score= DBA_SCORE_READS” for dba.count(), “method=DBA_DESEQ2,  normalize=DBA_NORM_NATIVE, library=DBA_LIBSIZE_PEAKREADS” for dba.normalize() and “bBlacklist = TRUE, bGreylist = TRUE, bParallel = TRUE” for dba.analyze(). Any confounding effect due to batch differences was controlled with the design argument in DiffBind. Given the varied nature of panH3ac peaks, differential ChIP peaks were assigned to the nearest gene with ChIP-Enrich.  Genes with cutoff values of ±0.58 log2 fold-change (log2FC) and adjusted P < 0.1 (Benjamini-Hochberg method) were considered differentially expressed.

### Statistical Analysis and Data Visualizations
All statistical analyses and data visualizations were performed with R, or within the used program (i.e., DESeq2, DiffBind, IPA). Statistical analyses conducted within R included Pearson correlation and Cox regression. Data visualizations, heatmaps and volcano plots were created with the R ggplot package, heatmap.2 package and EnhancedVolcano package, respectively.  

## Instructions  
1. File/directory setup  
To run the RNA-seq preprocessing, clone the git repo, download the fastq files and set up in a folder structure like:    
 ./RNA_seq/fastq/    
 ./RNA_seq/**script files to go here**  
 ./RNA_seq/counts/**count matrix to go here** 
 ./ChIP_seq/group_1_fastq/**ChIPseq group1 files can be identified by \*Moff_Pt\*.fastq.gz and \*Moff_Pooled\*.fastq.gz** 
 ./ChIP_seq/group_2_fastq/**remaining fastq files areChIPseq group2**  
 ./ChIP_seq/**script files to go here**  
 ./ChIP_seq/peaks_group1**group1 peaks files to go here**
 ./ChIP_seq/peaks_group2**sgroup2 peaks files to go here**
 ./genome/download NCBI genome and GTF here  

 Genomic Sequence Downloads:  
  [GRCh38 for RNAseq](https://www.ncbi.nlm.nih.gov/projects/genome/guide/human/index.shtml#download)  See the HiSAT2 manual for using this genome to build a HiSAT2 index.  
  [GRCh38 for Chipseq](https://genome-idx.s3.amazonaws.com/bt/GRCh38_noalt_as.zip) See Bowtie2 help for building an indexed version. 
  [RefSeq GTF](https://www.ncbi.nlm.nih.gov/data-hub/genome/GCF_000001405.40/) 

2. RNA-seq Pre-processing  

   From the RNAseq directory, make sure the fastq.gz files are arranged in a folder named RNA-seq, then in subfolders named for the Patient ID and Cell type, e.g. Pt01_CD4, Pt01_CD8, Pt02_CD4, etc. Copy the shell scripts to the project root folder to run the following:  
   a. run_lane_merge_fq.sh  
   b. run_hisat_pe.sh  
   c. htseq_counts.sh  
   This will produce a counts matrix, also included in the repo if you prefer to skip directly to downstream analysis.  

3. ChIP-seq Pre-processing: From the ChIPseq dir run:    
- chip.sh   

4. RNA-seq downstream analysis: From the RNA_seq/ dir, use R Studio to run:  
 - Figure_1.Rmd
 - DESeq2_TIL_RNAseq.Rmd    
 - RNAseq_vis.Rmd

 5. ChIP-seq downstream analysis, from the ChIP_Seq/ dir, use R Studio to run:  
 - ChIP-seq.Rmd


