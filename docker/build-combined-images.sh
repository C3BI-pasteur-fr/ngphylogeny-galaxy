#!/bin/bash
# Builds the combined images for tools with no bioconda package (phyml-sms,
# noisy - see docker/combined-images/*/Dockerfile) inside the galaxy
# container's own internal Docker daemon (enabled by `privileged: true` in
# docker-compose.yml). Run this once after `docker compose up -d`, and again
# any time those Dockerfiles change.
#
# Usage: ./docker/build-combined-images.sh [container_name_or_id]
# Defaults to the running `galaxy` service from docker-compose.yml.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER="${1:-}"

if [ -z "$CONTAINER" ]; then
    CONTAINER="$(docker compose -f "$SCRIPT_DIR/../docker-compose.yml" ps -q galaxy)"
fi

if [ -z "$CONTAINER" ]; then
    echo "Could not find the running galaxy container. Pass its name/id as an argument." >&2
    exit 1
fi

echo "Waiting for the galaxy container's internal Docker daemon to be ready..."
for _ in $(seq 1 60); do
    if docker exec "$CONTAINER" docker info >/dev/null 2>&1; then
        break
    fi
    sleep 5
done
if ! docker exec "$CONTAINER" docker info >/dev/null 2>&1; then
    echo "The internal Docker daemon never became ready (is the container running with privileged: true?)." >&2
    exit 1
fi

echo "Building local/phyml-sms-full:v1.8.1 ..."
docker exec -i "$CONTAINER" bash -c 'cd /tmp && docker build -f - -t local/phyml-sms-full:v1.8.1 .' \
    < "$SCRIPT_DIR/combined-images/phyml-sms-full/Dockerfile"

echo "Building local/noisy-full:v1.5.12 ..."
docker exec -i "$CONTAINER" bash -c 'cd /tmp && docker build -f - -t local/noisy-full:v1.5.12 .' \
    < "$SCRIPT_DIR/combined-images/noisy-full/Dockerfile"

echo "Done. phyml_sms.xml and noisy.xml reference these images directly."
