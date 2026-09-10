# evolbioinfo/phyml-sms doesn't have a bioconda package, so it can't be
# auto-resolved into a container the way most other tools in this repo are.
# This combines it with goalign/gotree (needed by phyml_sms.xml's own
# pre/post-processing steps) into one self-contained image.
#
# The base image's own ENTRYPOINT runs sms.sh directly, which breaks Galaxy's
# container execution model (it invokes `/bin/sh tool_script.sh` as the
# container command, expecting no entrypoint to intercept it) - clearing it
# is required, not optional.
FROM evolbioinfo/phyml-sms:v1.8.1
COPY --from=evolbioinfo/goalign:v0.3.6 /usr/local/bin/goalign /usr/local/bin/goalign
COPY --from=evolbioinfo/gotree:v0.2.10 /usr/local/bin/gotree /usr/local/bin/gotree
ENTRYPOINT []
