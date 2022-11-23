#!/bin/bash
# Author: Ann Strange
# Date: August 2022
# About: Preprocessing step 3 code for processing the TIL Epigenome RNAseq Data
## Script to run HISAT2 on PE fastq with lanes
# Download the NCBI GRCH38 p14 GTF file ex:
# https://www.ncbi.nlm.nih.gov/assembly/GCF_000001405.40

SOURCE="${PWD}/mapped_ncbi"
TARGET="${PWD}/counts"
GTF="${PWD}/../genome/NCBI_GRCh38_ht/GCF_000001405.40_GRCh38.p14_genomic.gtf"
PROCS=1


# if TARGET dne, create it (includes any subdirs)
mkdir -p "${TARGET}"

cd "${SOURCE}" 

echo "Using $PROCS threads"
echo " Counting paired mappings"
echo "gene $(basename -a $SOURCE/*.bam | sed 's/.bam//g' | tr '\n' '\t')" > $TARGET/counts.table

# default mode: --mode=union
echo "python3.8 -m HTSeq.scripts.count -n $PROCS --type=gene --idattr=gene_id -r name -s no --secondary-alignments=ignore --supplementary-alignments=ignore $(ls $SOURCE/*.bam) $GTF >> $TARGET/counts.table"
python3.8 -m HTSeq.scripts.count -n $PROCS --type gene --idattr gene_id -r name -s no --secondary-alignments=ignore --supplementary-alignments=ignore $(ls $SOURCE/*.bam) $GTF  >> $TARGET/counts.table

