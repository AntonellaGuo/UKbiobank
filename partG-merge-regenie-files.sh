#!/bin/sh

# Inputs:
# - /Data/assoc.c1_urticaria_cc.regenie.gz - regenie results for chromosome 1 
# - /Data/assoc.c2_urticaria_cc.regenie.gz - regenie results for chromosome 2 
# - /Data/assoc.c3_urticaria_cc.regenie.gz - regenie results for chromosome 3 
# - /Data/assoc.c4_urticaria_cc.regenie.gz - regenie results for chromosome 4 
# - etc.

# Outputs (for each chromosome):
# - /Data/assoc.regenie.merged.txt - merged results for all chromosomes in tab-delimited format

merge_cmd='out_file="assoc.regenie.merged.txt"

# Use dxFUSE to copy the regenie files into the container storage
cp /mnt/project/Data/*.regenie.gz .
gunzip *.regenie.gz

# add the header back to the top of the merged file
echo -e "CHROM\tGENPOS\tID\tALLELE0\tALLELE1\tA1FREQ\tN\tTEST\tBETA\tSE\tCHISQ\tLOG10P\tEXTRA" > $out_file

files="./*.regenie"
for f in $files
do
# for each .regenie file
# remove header with tail
# transform to tab delimited with tr
# save it into $out_file
   tail -n+2 $f | tr " " "\t" >> $out_file
done

# remove regenie files
rm *.regenie'

data_file_dir="Data"

dx run swiss-army-knife -iin="/${data_file_dir}/assoc.c1_urticaria_cc.regenie.gz" \
   -icmd="${merge_cmd}" --tag="Step1" --instance-type "mem1_ssd1_v2_x16"\
   --destination="${project}:/Data/" --brief --yes 