#!/bin/bash
#
let k=1
let nst=20
let nBootstrap=20
#
g_wham=g_wham_d
#
rm tpr-files.dat
rm pullf-files.dat
#
echo ' '
#
while [ $k -le $nst ] 
do
    let k1=k
    #
    echo ' Processing structure n...' $k1
    echo $k1-struct/umbrella.tpr >> tpr-files.dat
    echo $k1-struct/pullf-umbrella.xvg >> pullf-files.dat
    #
    let k=k+1
done
#
echo ' '
echo ' g_wham is running...'
echo ' '
#
$g_wham -it tpr-files.dat -if pullf-files.dat -o pmf.xvg -hist -unit kCal -v -nBootstrap $nBootstrap >& g_wham.log
#
echo ' '
echo ' Done'
echo ' '
