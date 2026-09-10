# evolbioinfo/noisy doesn't have a bioconda package, so it can't be
# auto-resolved into a container the way most other tools in this repo are.
# This combines it with goalign (needed by noisy.xml's own alphabet-detection
# step) into one self-contained image.
#
# The base image's own ENTRYPOINT runs noisy directly, which breaks Galaxy's
# container execution model (it invokes `/bin/sh tool_script.sh` as the
# container command, expecting no entrypoint to intercept it) - clearing it
# is required, not optional.
FROM evolbioinfo/noisy:v1.5.12
COPY --from=evolbioinfo/goalign:v0.3.6 /usr/local/bin/goalign /usr/local/bin/goalign
ENTRYPOINT []
