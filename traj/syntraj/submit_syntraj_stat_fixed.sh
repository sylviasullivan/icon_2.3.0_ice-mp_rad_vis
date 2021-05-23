#!/bin/ksh
#SBATCH --account=bb1018
#SBATCH --job-name=stat
#SBATCH --partition=compute
#SBATCH --mem=10gb
#SBATCH --nodes=1
#SBATCH --output=/work/bb1018/b380873/tropic_vis/traj/syntraj-profile/LOG_syntraj_stat.%j.o
#SBATCH --error=/work/bb1018/b380873/tropic_vis/traj/syntraj-profile/LOG_syntraj_stat.%j.o
#SBATCH --time=04:00:00

python statme_fixed.py
