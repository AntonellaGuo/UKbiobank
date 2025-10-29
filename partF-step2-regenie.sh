#!/bin/bash

# Part F. regenie step2

# Inputs:
# - /Data/urticaria_wes.phe
# - /Data/urticaria_results_1.loco.gz
# - /Data/urticaria_results_pred.list
# you will run a separate worker(for each chromosome)
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bed
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bam 
# - /Data/WES_c1_snps_qc_pass.snplist - from Part E

# Outputs (for each chromosome):
# - /Data/assoc.c1_urticaria_cc.regenie.gz - regenie results for chromosome 1 
# note that if you have multiple phenotypes, you will have a .regenie.gz for each phenotype
# - /Data/assoc.c1.log  - regenie log for chromosome 1

$project=$1
exome_file_dir="${project}:/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
data_field="23155"
data_file_dir="${project}:/Data/"


for chr in {1..22}; do
  run_regenie_cmd="regenie --step 2 --bed ukb${data_field}_c${chr}_b0_v1 --out assoc.c${chr}\
    --phenoFile urticaria_wes.phe --covarFile urticaria_wes.phe\
    --bt --approx --firth-se --firth --extract WES_c${chr}_snps_qc_pass.snplist\
    #phenotype colum and covariate columns in urticaria_wes.phe\
    --phenoCol urticaria_cc --covarCol age --covarCol sex --covarCol ever_smoked \
    --pred urticaria_results_pred.list --bsize 200\
    --pThresh 0.05 --minMAC 3 --threads 16 --gz"

  dx run swiss-army-knife \
   -iin="${exome_file_dir}/ukb${data_field}_c${chr}_b0_v1.bed" \ #bed file for chromosome
   -iin="${exome_file_dir}/ukb${data_field}_c${chr}_b0_v1.bim" \ #bim file for chromosome
   -iin="${exome_file_dir}/ukb2${data_field}_c${chr}_b0_v1.fam"\ #fam file for chromosome
   -iin="${data_file_dir}/WES_c${chr}_snps_qc_pass.snplist"\ #individual QC snplist produced with 04-step2-qc-filter.sh
   -iin="${data_file_dir}/urticaria_wes.phe" \
   -iin="${data_file_dir}/urticaria_results_pred.list" \ #Merged results produced from 03-step1-regenie.sh
   -iin="${data_file_dir}/urticaria_results_1.loco.gz" \ #Merged results produced from 03-step1-regenie.sh
   -icmd="${run_regenie_cmd}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/Data/" --brief --yes
done