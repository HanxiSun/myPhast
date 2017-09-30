#!/bin/sh

for acc in $(seq 2 1 4)
do
for lambda in $(seq 1.5 0.5 5)
do
for phi in $(seq 0.1 0.1 0.6)
do
for eta in $(seq 0.1 0.1 0.6)
do
if (( $(echo "$phi + $eta < 0.8" | bc -l) )); then
# run dless with acc lambda phi eta
./myPhast/bin/dless --acc-height $acc -L $lambda -p $phi -e $eta data/chr20ssub.fa data/chr20ssub.mod > ./v2_tests/v2_chr20ssub_$acc,$lambda,$phi,$eta.gff
# try phyloP
# phyloP --features v1_robust/v1_rb_$lambda,$phi,$eta.gff --mode CONACC hky.mod hmrc.fa > v1_robust/phyloP_rb_$lambda,$phi,$eta.txt
echo $acc,$lambda,$phi,$eta
fi
done
done
done
done