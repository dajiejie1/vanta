FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Vanta desktop for the current RTX 2080 PC. x86_64 supports AMD and Intel CPUs.
FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint