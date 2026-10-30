#!/bin/bash
set -e

generate_script() {
  local target=$1
  mkdir -p "$(dirname "$target")"
  cat > "$target" <<EOF
#!/bin/sh
# Generated jdupes command
exec jdupes $JDUPES_OPTIONS "$SOURCE_DIR"
EOF
  chmod +x "$target"
}

# Pick or create the script that will actually run
if [ -x "$SCRIPT_PATH" ]; then
  ACTIVE_SCRIPT="$SCRIPT_PATH"
  echo "Using existing script: $ACTIVE_SCRIPT"
elif [ "$WRITE_SCRIPT" = "true" ]; then
  generate_script "$SCRIPT_PATH"
  ACTIVE_SCRIPT="$SCRIPT_PATH"
  echo "Wrote script: $ACTIVE_SCRIPT"
else
  ACTIVE_SCRIPT="/tmp/run_jdupes.sh"
  generate_script "$ACTIVE_SCRIPT"
fi

setup_cron() {
  mkdir -p /etc/crontabs
  echo "$CRON_SCHEDULE $ACTIVE_SCRIPT >> /var/log/jdupes-cron.log 2>&1" > /etc/crontabs/root
  touch /var/log/jdupes-cron.log
  echo "Cron scheduled: $CRON_SCHEDULE"
}

run_once() {
  echo "Running: $ACTIVE_SCRIPT"
  "$ACTIVE_SCRIPT"
}

if [ -n "$CRON_SCHEDULE" ]; then
  setup_cron
  [ "$RUN_ON_STARTUP" = "true" ] && run_once
  echo "Starting cron..."
  crond -f -L /var/log/cron.log
elif [ "$RUN_ON_STARTUP" = "true" ]; then
  run_once
fi
