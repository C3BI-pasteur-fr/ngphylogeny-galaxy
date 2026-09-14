# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This repository holds the Galaxy tool wrappers and workflows that
[NGPhylogeny_fr_django](https://github.com/C3BI-pasteur-fr/NGPhylogeny_fr_django)
(the `ngphylogeny-django` repo) drives via the `bioblend` API. It contains
no Django/Python application code of its own — just Galaxy tool XML
wrappers (`tools/*/*.xml`), a `tool_conf.xml` listing them, four base
workflow definitions (`workflows/*.ga`), and a `docker-compose.yml` that
runs an actual Galaxy server against them. Changes here only take effect
once a running Galaxy instance picks them up (bind mount + restart, or a
fresh `docker compose up` — see "Local Galaxy instance" below); there's no
way to validate a tool wrapper without a real Galaxy to run it against.

## Tools and workflows

* Multiple alignment: Clustal Omega, MAFFT, Muscle, Noisy
* Alignment curation: BMGE, Gblocks, trimAl
* Tree inference: FastME, FastTree, MrBayes, PhyML, PhyML-SMS, TNT
* Others: goalign, Newick Utilities, booster, seqtypedetect

Four base workflows (`workflows/*.ga`), one per tree-inference tool:
FastME/FastTree/PhyML/PhyML-SMS OneClick. These need to be imported into
Galaxy once as `"<Tool> OneClick"` (exactly this name, no other copy) for
`NGPhylogeny_fr_django`'s own `importworkflows` command to find them — see
"Local Galaxy instance" below, and that repo's CLAUDE.md ("upgrade vs the
old master branch" / the `importworkflows` matching-pattern discussion) for
why the naming matters.

## Dependency resolution: conda vs container

`docker-compose.yml` runs the actively-maintained
[`quay.io/bgruening/galaxy`](https://github.com/bgruening/docker-galaxy-stable)
image in `privileged: true` mode, which enables its built-in Docker-in-Docker
daemon (`GALAXY_CONFIG_CONDA_AUTO_INSTALL=True`, `docker_dispatch` job
routing). This is what actually resolves each tool's runtime dependencies:

- Most tools declare an ordinary bioconda `<requirement>` and get
  auto-containerized on demand by Galaxy's `mulled`/`build_mulled` container
  resolvers — no extra setup, and no action needed here beyond getting the
  package name/version right (see "Requirement pins that look right but
  aren't" below).
- **PhyML-SMS** and **Noisy** have no bioconda package at all. Their tool
  XML instead declares an explicit `<container type="docker">` pointing at
  a small locally-built image (`docker/combined-images/*/Dockerfile`, each
  layering `goalign`/`gotree` onto the matching `evolbioinfo/*` base image).
  These images only exist inside the Galaxy container's own internal Docker
  daemon — build them there with `./docker/build-combined-images.sh` after
  `docker compose up -d` (and again any time those Dockerfiles change);
  they are never pulled from a registry automatically, and a `docker
  images` on the *host* will never show them.
- **TNT** has neither a bioconda package nor a Docker image available (it's
  under a license that requires downloading it manually from the Willi
  Hennig Society); its wrapper is present but won't run out of the box.

### Two traps specific to `<container type="docker">` tools

Only PhyML-SMS and Noisy hit these today, but they'll bite any other tool
moved onto an explicit container image:

- **A base image with its own `ENTRYPOINT` swallows Galaxy's invocation.**
  Galaxy runs a containerized tool as `/bin/sh tool_script.sh` *as arguments
  to the image's entrypoint* — if the base image already sets one (e.g.
  `evolbioinfo/phyml-sms`'s entrypoint is its own `sms.sh`), that intercepts
  Galaxy's script instead of running it. Diagnosed via `docker inspect
  <image>` showing a non-empty `Entrypoint`; fixed with `ENTRYPOINT []` in
  the combined-image Dockerfile (see `docker/combined-images/*/Dockerfile`).
- **Containerized jobs run via `/bin/sh`, not bash.** Bash-isms in a tool's
  `<command>` block — array syntax (`PARAMS=(); PARAMS+=(...)`) in
  particular — raise `Syntax error: "(" unexpected` under a container's
  `/bin/sh`, even though the exact same command block runs fine
  conda-resolved (which does invoke bash). Reproduce with `docker run
  --entrypoint /bin/sh <image> -c '...'`; fixed by rewriting to plain
  string variables (see `phyml_sms.xml`/`noisy.xml` for the pattern).

### Requirement pins that look right but aren't

Found by actually running each tool against a real Galaxy (`manage.py
test`-equivalent verification doesn't exist in this repo — every one of
these only surfaced as a real job failure):

- `bmge` (not `BMGE`) — bioconda package names are case-sensitive; the
  capitalized form silently resolves to nothing.
- `gotree=0.2.10`, not `0.3.1` — 0.3.1 was never published to bioconda.
- `newick_utils` (not `newick_utilities`) as the package name, pinned with
  `libxml2=2.13.9` — newer conda-forge `libxml2` builds ship an
  incompatible SONAME for the old `nw_display` binary. Also needs
  `coreutils` explicitly (the container base image lacks `csplit`, which
  `nw_display` shells out to).
- `parallel=20171222`, not `20170122` (fasttree) — the older build was
  pruned from bioconda.
- Drop unresolvable/vestigial requirements rather than guessing a fix:
  `gcc=9.2.0` on `phyml.xml` (unneeded — nothing in that tool actually
  needs a compiler at runtime) and `fasta=3.6` on `mafft.xml` (a stale,
  never-resolvable leftover) were both just removed, not repinned. `phyml`
  additionally needs `openssh` added — `mpirun` requires an `ssh` binary to
  be *present* even for purely local, single-node execution, even though it
  never actually connects anywhere.

## Disk usage: the `docker-prune` sidecar

Nothing about Galaxy's internal Docker-in-Docker daemon (see above) ever
prunes its own stopped tool-job containers or old images on its own - left
alone, they accumulate unbounded and can fill the host disk. This actually
happened on the real IFB Cloud deployment (2026-09-14): 5510 stopped
containers plus hundreds of stale images, tens of GB reclaimable, none of
it ever cleaned up, which took `NGPhylogeny_fr_django` down with a 500
(disk-full Postgres healthcheck failure) - see that repo's `IFB_CLOUD.md`
for the full incident writeup.

`docker-compose.yml`'s `docker-prune` service is the fix: a small sidecar
(`docker:27-cli`, host Docker socket mounted - same pattern as
`NGPhylogeny_fr_django/docker-compose.standalone.yml`'s
`galaxy-build-images`) that, every 2 days at 02:00 (container/host clock,
UTC by default), prunes both the `galaxy` service's internal daemon
(`docker exec <galaxy container> docker container/image prune -f`) and the
host's own. It resolves the galaxy container via its
`com.docker.compose.service=galaxy` label rather than a hardcoded name, so
it keeps working whether or not an override sets `container_name:` (the
real deployment's `docker-compose.prod.yml` does, to `ngphylo-galaxy`).
Check `docker compose logs docker-prune` if disk usage becomes a problem
again, to confirm it's actually running.

## Local Galaxy instance

```
docker compose up -d
./docker/build-combined-images.sh   # one-time, see above
```

Galaxy comes up on http://localhost:8080, admin login `admin`/`password`
(no API key or admin account is preconfigured by the base
`docker-compose.yml` alone — see the "Admin key" trap below if you add
one via an override). The `tools/` directory is bind-mounted in and used
directly (`tools/tool_conf.xml` lists every tool), so editing a tool's XML
and `docker compose restart galaxy` is enough to pick up changes — no
image rebuild needed.

A brand-new Galaxy has zero workflows. Import the 4 base `.ga` files once,
named exactly `"<Tool> OneClick"` (see "Tools and workflows" above) — either
by hand via bioblend (`gi.workflows.import_workflow_dict`, setting `name`
on the loaded JSON before importing), or automatically via
`NGPhylogeny_fr_django`'s `docker-compose.standalone.yml` /
`docker/import_base_workflows.py`, which does exactly this and is the
easier path if you're setting up a fresh instance rather than developing
against this repo in isolation.

### Ports gotcha in any compose override

If you write a `docker-compose.override.yml` (or a `-f a.yml -f b.yml`
combination) that re-publishes `galaxy`'s port — e.g. to bind it to
`127.0.0.1` only for a production-like deployment instead of the base
file's `0.0.0.0:8080` — use `ports: !override` (Compose v2.24+). Docker
Compose *concatenates* list-valued keys (`ports`, `volumes`, `expose`)
across `-f` files rather than replacing them, unlike map-valued keys like
`environment`, which merge per-key as expected. Without `!override`, the
service ends up bound to *both* the base file's port *and* your override's
— e.g. silently still exposed on `0.0.0.0:8080` to the whole network
despite an override that was supposed to make it localhost-only. Verify
with `docker inspect <container> --format
'{{json .NetworkSettings.Ports}}'` after bringing the stack up, every time
a `ports:` entry changes across layered files.

### Admin key gotcha in any compose override

If your override sets `GALAXY_DEFAULT_ADMIN_KEY` (a real admin user's API
key) to link this Galaxy to an external app, it must be a **different**
value from `GALAXY_CONFIG_BOOTSTRAP_ADMIN_API_KEY` (Galaxy's special
bootstrap key). Setting both to the same secret breaks Galaxy's own auth —
requests authenticated with that key get routed through the bootstrap path
instead of resolving to the real admin user, and any endpoint that queries
by the authenticated user (e.g. `/api/workflows/`) 500s with
`sqlalchemy.exc.ArgumentError: Mapped instance expected for relationship
comparison to object`. Since Galaxy only creates its default admin user
once on first boot, fixing this after the fact needs a fresh volume
(`docker compose down -v`), not just a restart.

## No CI

There's no `.gitlab-ci.yml`/GitHub Actions workflow in this repo — tool
wrapper correctness can only really be checked by running a real workflow
against a real Galaxy instance (see "Local Galaxy instance" above), which
isn't something a CI pipeline here currently does.
