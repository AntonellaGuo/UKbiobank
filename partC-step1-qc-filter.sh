#!/bin/sh
data_field="22418"

# Outputs:
# - /Data/WES_array_snps_qc_pass.snplist - Used as input for part D
# - /Data/WES_array_snps_qc_pass.log
# - /Data/WES_array_snps_qc_pass.id

#set output directory (also location of merged files)
data_file_dir="/Data/"

run_plink_qc="plink2 --bfile ukb${data_field}_c1_22_v2_merged\
 --keep urticaria_wes.phe --autosome\
 --maf 0.01 --mac 20 --geno 0.1 --hwe 1e-15\
 --mind 0.1 --write-snplist --write-samples\
 --no-id-header --out  WES_array_snps_qc_pass"

dx run swiss-army-knife \
   -iin="${data_file_dir}/ukb${data_field}_c1_22_v2_merged.bed" \
   -iin="${data_file_dir}/ukb${data_field}_c1_22_v2_merged.bim" \
   -iin="${data_file_dir}/ukb${data_field}_c1_22_v2_merged.fam"\
   -iin="${data_file_dir}/urticaria_wes.phe" \
   -icmd="${run_plink_qc}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/Data/" --brief --yes