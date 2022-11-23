#!/bin/bash
# Author: Ann Strange
# Date: August 2022
# About: Preprocessing step 2 code for processing the TIL Epigenome RNAseq Data

## Script to run HISAT2 on PE fastq with lanes

# Directories for intput/output files
SOURCE="${PWD}/merged_fq"
TARGET="${PWD}/mapped_ncbi"
GENOMEDIR="${PWD}/../genome/NCBI_GRCh38_ht/NCBI_GRCh38_ht"

# Number of processes/threads to use
THREADS=8

# if TARGET dne, create it (includes any subdirs)
mkdir -p "${TARGET}"
cd "${SOURCE}" 

# loop to run fastqc for each
ls ${SOURCE}/*.fastq*

for f in $(ls ${SOURCE}/*_R1.fastq* ); do
  # make pairs

  # does the matching R2 file exist? 
  # string replace to replace _R1_ with _R2_ (will always appear at end of filename like _R1_001.fastq.gz)
  f2="${f/_R1/_R2}"
  if [ ! -f "$f2" ]; then
      echo "pair ${f2} file not found"
  else
      echo "Pair found"    
  fi

  # string substitution to derive output file
  bam_file="${f/$SOURCE/$TARGET}"
  bam_file="${bam_file/_R1/}"
  bam_file="${bam_file/_L00?/}"
  bam_file="${bam_file/.fastq.gz/.bam}"
  bam_file="${bam_file/.fastq/.bam}"
  
  echo "file for output: $bam_file"
  echo Job started at `date +"%T %a %d %b %Y"`

  HISAT="hisat2 -p $THREADS -x $GENOMEDIR -1 $f \
  -2 $f2 -S ${bam_file} "
  echo ""
  echo "Hisat2 commands:"
  echo "$HISAT"
  eval $HISAT
  echo Job finished at `date +"%T %a %d %b %Y"`
done  




