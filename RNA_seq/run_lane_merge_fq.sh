#!/bin/bash
# Author: Ann Strange
# Date: August 2022
# About: Preprocessing step 1 code for processing the TIL Epigenome RNAseq Data
#        Merge lane fastq files

SOURCE="${PWD}/fastq"
TARGET="${PWD}/merged_fq"
THREADS=8

echo "Source: $SOURCE";
echo "Target: $TARGET";
echo "Threads: $THREADS";

# if TARGET dne, create it (includes any subdirs)
mkdir -p "${TARGET}"
cd "${SOURCE}" 

# loops through dirs to find fastq or fastq.gz files
for d in $(grep '.*_.*' <(ls "${SOURCE}")); do
   if [ -d "${SOURCE}/$d" ]; then
      echo "$d is a directory, files:"
      echo "ls ${SOURCE}/$d/*.fastq* "
      ls ${SOURCE}/$d/*.fastq*
      # inner loop to run fastqc for each
      
      ### R1 #####
      CATCMD="cat "
      for f in $(ls ${SOURCE}/$d/*_R1_*.fastq* ); do

        CATCMD="$CATCMD $f"
        echo "$CATCMD"
        
      done  
      
      # make outfile name out of last filename w string substitutions
      outfile="${f/$SOURCE/$TARGET}"
      outfile="${outfile/\/$d/}"
      outfile="${outfile/_001/}"

      CATCMD="${CATCMD} > $outfile"
      echo "$CATCMD"
      eval $CATCMD

      ### R2 #####
      CATCMD="cat "
      for f in $(ls ${SOURCE}/$d/*_R2_*.fastq* ); do

        CATCMD="$CATCMD $f"
        echo "$CATCMD"
        
      done  
      
      # make outfile name out of last filename w string substitutions
      outfile="${f/$SOURCE/$TARGET}"
      outfile="${outfile/\/$d/}"
      outfile="${outfile/_001/}"

      CATCMD="${CATCMD} > $outfile"
      echo "$CATCMD"
      eval $CATCMD
   fi
done
