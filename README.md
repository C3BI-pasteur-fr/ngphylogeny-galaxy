# NGPhylogeny.fr : galaxy

This repository contains tools and workflows used in [NGPhylogeny.fr](https://github.com/C3BI-pasteur-fr/NGPhylogeny_fr_django/).


## Tools
Wrappers for several phylogenetic tools are defined:

* Mutliple alignment:
  * Clustal Omega
  * MAFFT
  * Muscle
  * Noisy
* Alignment curation:
  * BMGE
  * Gblocks
* Tree inference:
  * FastME
  * FastTree
  * MrBayes
  * PhyML
  * PhyML-SMS
  * TNT
* Others
  * goalign
  * Newick Utilities

## Workflows

Using these tools, several workflows are defined:

* FastME OneClick: Complete workflow using FastME
* FastTree OneClick: Complete workflow using FastTree
* PhyML-SMS OneClick: Complete workflow using PhyML-SMS
* PhyML OneClick: Complete workflow using PhyML

## Galaxy instance
To test these galaxy tools and workflows, you can use the [docker image](https://hub.docker.com/r/evolbioinfo/ngphylogeny-galaxy/) automatically built on docker hub:

```
docker run --privileged=true \
           -p 8080:80 \
		   -p 8121:21 \
		   -p 8122:22 \
		   evolbioinfo/ngphylogeny-galaxy
```

This image integrates a running galaxy instance, with all phylogenetic tools installed on environment modules using singularity images.
