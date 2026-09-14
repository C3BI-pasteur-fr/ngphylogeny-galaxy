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

```
docker compose up -d
./docker/build-combined-images.sh   # one-time, see below
```

Galaxy comes up on http://localhost:8080. The `tools/` directory is bind-mounted
into the container and used directly (`tools/tool_conf.xml` lists every tool),
so editing a tool's XML and restarting the container (`docker compose restart galaxy`)
is enough to pick up changes - no image rebuild needed.

`docker-compose.yml` runs the actively-maintained [`quay.io/bgruening/galaxy`](https://github.com/bgruening/docker-galaxy-stable)
image in `privileged: true` mode, which enables its built-in Docker-in-Docker
daemon. This lets Galaxy run tools as containers:

* Tools with a resolvable bioconda package (the majority - MAFFT, PhyML,
  BMGE, FastTree, MrBayes, ...) are auto-containerized on demand by Galaxy's
  `mulled`/`build_mulled` container resolvers - no extra setup.
* **PhyML-SMS** and **Noisy** have no bioconda package at all, so their tool
  XML instead declares an explicit `<container>` pointing at a small
  locally-built image (`docker/combined-images/*/Dockerfile`, each layering
  `goalign`/`gotree` onto the matching `evolbioinfo/*` base image). These
  images only exist inside this Galaxy container's own internal Docker
  daemon, so they need to be built there once with
  `./docker/build-combined-images.sh` after the stack comes up (and again if
  those Dockerfiles change) - they are not pulled from a registry
  automatically.
* **TNT** has neither a bioconda package nor a Docker image available (it's
  under a license that requires downloading it manually from the Willi
  Hennig Society); its tool wrapper is present but won't run out of the box.

`docker-compose.yml` also runs a `docker-prune` sidecar that periodically
cleans up that internal Docker-in-Docker daemon's stopped containers/old
images (they otherwise accumulate unbounded and can fill the host disk) -
see CLAUDE.md's "Disk usage: the `docker-prune` sidecar" for details.
