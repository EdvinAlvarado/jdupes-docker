FROM alpine:latest

RUN apk add --no-cache jdupes bash

ENV SOURCE_DIR=/data \
    JDUPES_OPTIONS="-rMS" \
    CRON_SCHEDULE="" \
    RUN_ON_STARTUP="false" \
    WRITE_SCRIPT="false" \
    SCRIPT_PATH="/scripts/run_jdupes.sh"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]