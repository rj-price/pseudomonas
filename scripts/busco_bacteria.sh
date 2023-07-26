#!/usr/bin/env bash
#SBATCH -J busco
#SBATCH --partition=medium
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

# assembly (in .fasta format) = $1

export MYCONDAPATH=/mnt/shared/scratch/jnprice/apps/conda
source ${MYCONDAPATH}/bin/activate busco

fileshort=$(basename $1 | sed s/".fasta"//g)

busco -m genome -c 4 -i $1 -o BUSCO_$fileshort -l /mnt/shared/home/jnprice/busco_downloads/lineages/bacteria_odb10
