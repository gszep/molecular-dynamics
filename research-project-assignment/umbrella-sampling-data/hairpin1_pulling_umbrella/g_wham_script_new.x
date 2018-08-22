#!/bin/bash
#
let nst=21
let nBootstrap=$1
#
rm tpr-files.dat
rm pullf-files.dat
#
echo $nBootstrap
echo ' '
#
for k in $(seq -w 01 $nst)
do
    echo ' Processing structure n...' $k
    echo $k-struct/umbrella.tpr >> tpr-files.dat
    echo $k-struct/pullf-umbrella.xvg >> pullf-files.dat
done
#
echo ' '
echo ' g_wham is running...'
echo ' '
#
g_wham -it tpr-files.dat -if pullf-files.dat -o pmf.xvg -hist -unit kCal -v -nBootstrap $nBootstrap -tol 1e-5
mv bsResult.xvg bsResult$nBootstrap.xvg
rm \#*
#
echo ' '
echo ' Done'
echo ' '
