#!/bin/bash -l
#
if [ $# -ne 1 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: script <molname>"
    exit 1
fi
#
# name of job
mol=$1
#
source ~/bin/GMXRC.456_double_mpi.bash
# number of cpu
cpu=4
# name of files
#
# mpi binary
mpirun=/usr/bin/mpirun.openmpi
# gromacs binary
grompp=grompp_mpi_d
mdrun=mdrun_mpi_d
# list of sim to run



# Short equilibration
$grompp -f npt_umbrella.mdp -c struct.gro -p ../topol.top -n ../index.ndx -o npt.tpr  -maxwarn 10 >& grompp_$job.log
srun -J $mol -p long -N 1 --ntasks=1 --cpus-per-task=1  -n $cpu $mdrun -deffnm npt

# Umbrella run
$grompp -f md_umbrella.mdp -c npt.gro -t npt.cpt -p ../topol.top -n ../index.ndx -o umbrella.tpr  -maxwarn 10 >& grompp_$job.log
srun -J $mol -p long -N 1 --ntasks=1 --cpus-per-task=1  -n $cpu $mdrun -deffnm umbrella -pf pullf-umbrella.xvg -px pullx-umbrella.xvg






















