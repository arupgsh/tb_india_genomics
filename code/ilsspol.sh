#!/bin/bash
#$ -N spol
#$ -cwd
#$ -e logs/ils_spol.err 
#$ -o logs/ils_spol.out


#sample=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $2}' ils_samples.tsv)
#predict spoligotypes
python2.7 tools/SpoTyping/SpoTyping-v2.1-commandLine/SpoTyping.py -s off -m 10 -r 12 ../ils_sequencing/fastq/${sample}_R1_001.fastq.gz ../ils_sequencing/fastq/${sample}_R2_001.fastq.gz –o sopligo/${sample}_spo.out

python2.7 tools/SpoTyping/SpoTyping-v2.1-commandLine/SpoTyping.py -s off -m 20 -r 12 ../ils_sequencing/fastq/WGS10_S8_R1_001.fastq.gz ../ils_sequencing/fastq/WGS10_S8_R2_001.fastq.gz
