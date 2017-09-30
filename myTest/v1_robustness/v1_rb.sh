#!/bin/sh

for lambda in $(seq 1.5 0.5 3)
do
for phi in $(seq 0.1 0.1 0.6)
do
for eta in $(seq 0.1 0.1 0.6)
do
if (( $(echo "$phi + $eta < 0.8" | bc -l) )); then
# run dless for lambda phi eta
../phast_temp.v1/bin/dless -L $lambda -p $phi -e $eta hmrc.fa hky.mod > ./v1_robustness/v1_rb_$lambda,$phi,$eta.gff
# try phyloP
# phyloP --features v1_robust/v1_rb_$lambda,$phi,$eta.gff --mode CONACC hky.mod hmrc.fa > v1_robust/phyloP_rb_$lambda,$phi,$eta.txt
echo $lambda,$phi,$eta
fi
done
done
done