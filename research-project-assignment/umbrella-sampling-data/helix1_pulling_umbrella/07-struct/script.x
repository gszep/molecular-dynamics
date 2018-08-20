#!/bin/bash

MPIRUN=/usr/bin/mpirun
grompp=grompp_mpid
mdrun=mdrun_mpid

source ~/.GM455mpid

nprocs=8
job=npt


# Short equilibration
$grompp -f npt_umbrella.mdp -c struct.gro -p ../topol.top -n ../index.ndx -o npt.tpr  -maxwarn 10 >& grompp_$job.log
$MPIRUN -np $nprocs $mdrun -deffnm npt

# Umbrella run
$grompp -f md_umbrella.mdp -c npt.gro -t npt.cpt -p ../topol.top -n ../index.ndx -o umbrella.tpr  -maxwarn 10 >& grompp_$job.log
$MPIRUN -np $nprocs $mdrun -deffnm umbrella -pf pullf-umbrella.xvg -px pullx-umbrella.xvg







