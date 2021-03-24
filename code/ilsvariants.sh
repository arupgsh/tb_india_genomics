#!/bin/bash
#$ -N var
#$ -cwd
#$ -e logs/ils_variant.err 
#$ -o logs/ils_variant.out

export PATH="/software/samtools-1.9/:$PATH"
export PATH="/userdata/arup/Mtb_datasets/analysis/tools/sambamba/:$PATH"
#set paths for resources
#dir_name=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $1}' ils_samples.tsv)
#sample=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $2}' ils_samples.tsv)

#align public dataset
#/software/bwa-0.7.17/bwa mem -t 1 -Y -K 100000 -R "@RG\tID:FLOWCELL1.LANE1\tPL:ILLUMINA\tLB:Group1\tSM:${sample}" reference/h37rv.fasta ../${dir_name}/fastq/${sample}_R1_001.fastq.gz ../${dir_name}/fastq/${sample}_R2_001.fastq.gz |/software/samtools-1.9/samtools view -@ 1 -Sbo aligned/${sample}.bam

#sort aligned bam files
#/software/samtools-1.9/samtools sort -@1 -o sorted/${sample}.bam aligned/${sample}.bam
#/software/samtools-1.9/samtools index sorted/${sample}.bam


#align ils data
tools/bbmap/callvariants.sh -Xmx200g in=dedup/merged_ils.bam minreads=30 ref=reference/h37rv.fasta minscore=40.0 ploidy=1 out=variants/ils_variants.vcf
