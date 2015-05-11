#!/bin/bash
NAME=$1
TYPE=$2
qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad1 std $TYPE" $NAME
qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad2 std $TYPE" $NAME
qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad3 std $TYPE" $NAME

qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad1 user $TYPE" $NAME
qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad2 user $TYPE" $NAME
qsub -q l_short -N SKIB_TEST -l nodes=2:ppn=12 -l walltime=03:00:00 -F "zad3 user $TYPE" $NAME
