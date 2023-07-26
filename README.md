# Pseudomonas BUSCO Phylogeny
Testing BUSCO phylogeny on a subset of Pseudomonas spp. genomes.

## Download and prepare genomes
Make directory for analysis and move into it.
```
mkdir ~/scratch/pseudomonas
cd ~/scratch/pseudomonas
```

Make a file for the GenBank references of the required genomes and paste in the list of references and species names so that each is on a new line.
```
nano genomes.list

cat genomes.list

GCA_002905875.2 P_amygdali
GCA_002905795.2 P_avellanae
GCA_000007565.2 P_putida
GCA_000012205.1 P_savastanoi
GCA_000007805.1 P_syringae
GCA_000012245.1 P_syringae
GCA_002905835.1 P_syringae
GCA_900184295.1 P_viridiflava
```

Read line by line through genomes.list file and recursively download genomes from NCBI.
```
conda activate ncbi_datasets

cat genomes.list | while read REF SPECIES;
    do datasets download genome accession $REF --filename $REF.zip
    done
```

Unzip (and then delete zip files), rename and copy genomes to a new folder.
```
for file in *zip; do unzip -o $file; done
rm *zip

mkdir busco

cat genomes.list | while read REF SPECIES;
    do cp ncbi_dataset/data/$REF/$REF*fna busco/"$REF"_"$SPECIES".fasta
    done
```

## Run BUSCO and generate phylogeny
Run BUSCO submission script on genomes.
```
cd busco

for file in *fasta;
    do sbatch ../scripts/busco_bacteria.sh $file
    done
```

Using [BUSCO phylogenomics pipeline](https://github.com/jamiemcg/BUSCO_phylogenomics) generate concatenated protein alignment of shared BUSCOs and plot tree.
```
cd ..

sbatch scripts/busco_phylo.sh busco/
```

Download tree file ```SUPERMATRIX.phylip.treefile``` and view in [iTOL](https://itol.embl.de/).