# jdupes-docker
Docker to run jdupes with a script or not



## Environment Variables

- WRITE_SCRIPT: Set to "true" to generate the script at SCRIPT_PATH if there isn't an existing executable script.
- SCRIPT_PATH: Path to the script to run jdupes.
- JDUPES_OPTIONS: Options to pass to the jdupes script generation or execution. Are ignored if an existing executable script is used.
- SOURCE_DIR: Directory to scan for duplicates.
- CRON_SCHEDULE: Cron schedule for running the script. If none is specified, the script will run only once on startup if RUN_ON_STARTUP is set to "true".
- RUN_ON_STARTUP: Set to "true" to run the script immediately on container startup.