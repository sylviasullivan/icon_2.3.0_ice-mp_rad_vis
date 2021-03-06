#!/bin/ksh
#SBATCH --account=bb1018
#SBATCH --job-name=ap2pl
#SBATCH --partition=compute2
#SBATCH --mem=80gb
#SBATCH --nodes=8
#SBATCH --output=/work/bb1018/b380873/tropic_vis/logs/LOG_ap2pl.run.%j.o
#SBATCH --error=/work/bb1018/b380873/tropic_vis/logs/LOG_ap2pl.run.%j.o
#SBATCH --time=04:00:00

# Directory and inputs to build the file names.
basedir='/scratch/b/b380873/0V2M1A1R/'
fileprefix1='WINDTH_3D'
fileprefix2='WT'
lowtimestep=1
hightimestep=24

for timestep in $(seq $lowtimestep $hightimestep); do
    echo $timestep

    # How many leading zeros for the timestep in the filename?
    if [ ${#timestep} -eq 1 ]; then
       timestepprefix='000'
    elif [ ${#timestep} -eq 2 ]; then
       timestepprefix='00'
    elif [ ${#timestep} -eq 3 ]; then
       timestepprefix='0'
    else
       echo 'Incorrect time step specified.'
    fi

    # Read the pressure levels from the txt file. Add them line by line to $pressures.
    # c counts how many pressures are specified.
    c=0
    pressures=
    while read -r line; do pressures=$pressures$line','; c=$((c+1)); done < PMEAN_48-72.txt
    echo $c' pressures specified'

    # Remove the last comma from $pressures.
    pressures="${pressures%?}"

    # Simpler route. Pressures must [=] Pa.
    #pressures='90000,85000,75000,50000,25000'

    # Assemble the filenames and command.
    part1='cdo -b 32 -ap2pl,'
    part2='-selvar,pres_sfc,air_pressure,temp,omega'
    inputfile=$basedir$fileprefix1'_icon_tropic_'$timestepprefix$timestep'.nc'
    outputfile=$basedir$fileprefix2'_icon_tropic_'$timestepprefix$timestep'_PL2.nc'

    # Rename pres as air_pressure in the $inputfile.
    cdo chname,pres,air_pressure $inputfile $basedir'temp3.nc'
    cmd=$part1$pressures' '$part2' '$basedir'temp3.nc '$outputfile

    # Evaluate the command as you would from the command line.
    eval $cmd
done
