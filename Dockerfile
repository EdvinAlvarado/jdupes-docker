FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends jdupes bash cron && \
    rm -rf /var/lib/apt/lists/*

ENV SOURCE_DIR=/data \
    JDUPES_OPTIONS="-rMS" \
    CRON_SCHEDULE="" \
    RUN_ON_STARTUP="false" \
    WRITE_SCRIPT="false" \
    SCRIPT_PATH="/scripts/run_jdupes.sh"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]