#!/bin/bash
set -e

generate_script() {
  local target=$1
  mkdir -p "$(dirname "$target")"
  cat > "$target" <<EOF
#!/bin/sh
# Generated jdupes command
exec jdupes $JDUPES_OPTIONS "$SOURCE_DIR" -y "$JDUPES_DB"
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
  printf '%s %s >> /var/log/jdupes-cron.log 2>&1\n' "$CRON_SCHEDULE" "$ACTIVE_SCRIPT" | crontab -
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
  if command -v crond >/dev/null 2>&1; then
    crond -f -L /var/log/cron.log
  else
    cron -f
  fi
else
  run_once
fi
