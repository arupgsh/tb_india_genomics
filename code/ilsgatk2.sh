#!/bin/bash
#$ -N gat2
#$ -cwd
#$ -e logs/ils_gatk2.err 
#$ -o logs/ils_gatk2.out

#export PATH="/software/samtools-1.9/:$PATH"
#export PATH="/userdata/arup/Mtb_datasets/analysis/tools/sambamba/:$PATH"
#set paths for resources
#dir_name=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $1}' ils_samples.tsv)
#sample=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $2}' ils_samples.tsv)

#align public dataset
#/software/bwa-0.7.17/bwa mem -t 1 -Y -K 100000 -R "@RG\tID:FLOWCELL1.LANE1\tPL:ILLUMINA\tLB:Group1\tSM:${sample}" reference/h37rv.fasta ../${dir_name}/fastq/${sample}_R1_001.fastq.gz ../${dir_name}/fastq/${sample}_R2_001.fastq.gz |/software/samtools-1.9/samtools view -@ 1 -Sbo aligned/${sample}.bam

#sort aligned bam files
#/software/samtools-1.9/samtools sort -@1 -o sorted/${sample}.bam aligned/${sample}.bam
#/software/samtools-1.9/samtools index sorted/${sample}.bam


#align ils data
/userdata/arup/miniconda3/bin/java -Xmx150G -jar tools/gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 26 -ploidy 1 -I dedup/merged_ils.bam -R reference/h37rv.fasta -o variants/gatk_call2.vcf -glm SNP
