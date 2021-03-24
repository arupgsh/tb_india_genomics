#!/bin/bash
#$ -N beijing
#$ -cwd
#$ -t 1-161
#$ -e logs/beijing_snvcall.err 
#$ -o logs/beijing_snvcall.out

#set paths for resources
#dir_name=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $1}' sample_list1.tsv)
#sample=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $2}' sample_list1.tsv)
#beijing samples
sample=$(awk -F"\t" -v "line=$SGE_TASK_ID" 'NR==line {print $1}' beijingsamples.tsv)
#wait
#align public dataset
#/software/bwa-0.7.17/bwa mem -t 1 -Y -K 100000 -R "@RG\tID:FLOWCELL1.LANE1\tPL:ILLUMINA\tLB:Group1\tSM:${sample}" reference/h37rv.fasta ../${dir_name}/fastq/${sample}_1.fastq.gz ../${dir_name}/fastq/${sample}_2.fastq.gz |/software/samtools-1.9/samtools view -@ 1 -Sbo aligned/${sample}.bam

#sort aligned bam files
#/software/samtools-1.9/samtools sort -@1 -o sorted/${sample}.bam aligned/${sample}.bam
#/software/samtools-1.9/samtools index beijing_data/${sample}.sam_sorted.bam
#wait
#merge bam files
#/software/samtools-1.9/samtools  merge -@ 30 merged/merged.bam sorted/*.bam

#mark and remove duplicates
#java -Xmx4g -Djava.io.tmpdir=/userdata/arup/Mtb_datasets/analysis/tmp1 -jar /software/picard-2.20.3/picard.jar MarkDuplicates I=beijing_data/${sample}.sam_sorted.bam O=beijing/dedup/${sample}.bam M=beijing/dedup/${sample}.table REMOVE_DUPLICATES=true AS=true
#wait
#inded deduplicated bam files
#/software/samtools-1.9/samtools index beijing/dedup/${sample}.bam
#wait
#call variants from the data
#/userdata/arup/miniconda3/bin/java -Xmx8g -Djava.io.tmpdir=/userdata/arup/Mtb_datasets/analysis/tmp2 -jar tools/gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 1 -ploidy 1 -I dedup_all/${sample}.bam -R reference/h37rv.fasta -o sample_variants/gatk/raw_variants/${sample}.vcf.gz -glm BOTH -allowPotentiallyMisencodedQual

#/userdata/arup/miniconda3/bin/java -Xmx8g -Djava.io.tmpdir=/userdata/arup/Mtb_datasets/analysis/tmp2 -jar tools/gatk/GenomeAnalysisTK.jar -T UnifiedGenotyper -ploidy 1 -I beijing/dedup/${sample}.bam -R reference/h37rv.fasta -o beijing/variants/${sample}.vcf.gz -glm BOTH -allowPotentiallyMisencodedQuals

#filter raw variants
#filtered_variants

## Bcftool mpile up variant calling
#/userdata/arup/miniconda3/envs/mtbpipe/bin/bcftools mpileup --count-orphans --no-BAQ --min-BQ 20 --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR --fasta-ref reference/h37rv.fasta beijing/dedup/${sample}.bam > snv_calling/pileup/${sample}.pileup

## Raw variant calling using depth filter of 10
#/userdata/arup/miniconda3/envs/mtbpipe/bin/bcftools call --output-type v --ploidy 1 --keep-alts --keep-masked-ref --multiallelic-caller --variants-only snv_calling/pileup/${sample}.pileup | /userdata/arup/miniconda3/envs/mtbpipe/bin/bcftools view --output-file snv_calling/raw_vcf/${sample}.vcf.gz --output-type z --include 'INFO/DP>=10'

cat reference/h37rv.fasta | /userdata/arup/miniconda3/envs/mtbpipe/bin/bcftools consensus snv_calling/raw_vcf/${sample}.vcf.gz | /userdata/arup/miniconda3/envs/mtbpipe/bin/seqtk rename - ${sample} > consensus/${sample}_consensus.fa
