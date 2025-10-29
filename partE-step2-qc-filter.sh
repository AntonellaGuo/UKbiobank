#!/bin/bash

#Part E. QC WES files by chromosome

# Inputs:
# - /Data/urticaria_wes.phe
# you will run a separate worker (for each chromosome)
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bed - Chr1 file 
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bim 
# - /{exome_file_dir}/ukb23155_c1_b0_v1.bam 
# - /Data/ukb22418_c1_22_v2_merged.bed - from part B
# - /Data/ukb22418_c1_22_v2_merged.bed - from part B

# Outputs (for each chromosome):
# - /Data/WES_c1_snps_qc_pass.id  
# - /Data/WES_c1_snps_qc_pass.snplist - used in Part F 
# - /Data/WES_c1_snps_qc_pass.log


#set this to the exome sequence directory that you want (should contain PLINK formatted files)
exome_file_dir="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release"
data_field="23158"
data_file_dir="/Data/"

for i in {1..22}; do
    run_plink_wes="plink2 --bfile ukb${data_field}_c${i}_b0_v1\
      --no-pheno --keep urticaria_wes.phe --autosome\
      --maf 0.01 --mac 20 --geno 0.1 --hwe 1e-15 --mind 0.1\
      --write-snplist --write-samples --no-id-header\
      --out WES_c${i}_snps_qc_pass"

    dx run swiss-army-knife \
     -iin="${exome_file_dir}/ukb${data_field}_c${i}_b0_v1.bed" \
     -iin="${exome_file_dir}/ukb${data_field}_c${i}_b0_v1.bim" \
     -iin="${exome_file_dir}/ukb${data_field}_c${i}_b0_v1.fam" \
     -iin="${data_file_dir}/urticaria_wes.phe" \
     -icmd="${run_plink_wes}" --tag="Step2" --instance-type "mem1_ssd1_v2_x16"\
     --destination="${project}:/Data/" --brief --yes
done