#!/bin/bash

gfortran script-ions.f90 -o script-ions
gfortran script-flux.f90 -o script-flux
gfortran script-curr.f90 -o script-curr

cp ./script-* ../research-project-assignment/md-electric-field-data/1000mV/plus-1000mV/
cp ./script-* ../research-project-assignment/md-electric-field-data/1000mV/minus-1000mV/

cp ./script-* ../research-project-assignment/md-electric-field-data/100mV/plus-100mV/
cp ./script-* ../research-project-assignment/md-electric-field-data/100mV/minus-100mV/

cp ./script-* ../research-project-assignment/md-electric-field-data/200mV/plus-200mV/
cp ./script-* ../research-project-assignment/md-electric-field-data/200mV/minus-200mV/
