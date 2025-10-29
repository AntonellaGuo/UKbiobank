#!/bin/sh

# Part B.  merging genotype files

# Inputs
# - /Data/urticaria_wes.phe

# Outputs
# - ukb22418_c1_22_v2_merged.bed
# - ukb22418_c1_22_v2_merged.bim
# - ukb22418_c1_22_v2_merged.fam

run_merge="cp /mnt/project/Bulk/Genotype\ Results/Genotype\ calls/ukb22418_c[1-22]* . ;\
        ls *.bed | sed -e 's/.bed//g'> files_to_merge.txt; \
        plink --merge-list files_to_merge.txt --make-bed\
        --autosome-xy --out ukb22418_c1_22_v2_merged;\
        rm files_to_merge.txt;"

dx run swiss-army-knife -iin="/Data/urticaria_wes.phe" \
   -icmd="${run_merge}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="/Data/" --brief --yes

