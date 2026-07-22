# cohort-2-usecase

This repository includes shell scripts for generating a sample workspace and backing up project directories.

## Included scripts
- `generate_workspace.sh`: creates a sample workspace with `WebApp` and `API` directories, basic files, and asset placeholders.
- `backup_project.sh`: backs up a specified project directory into `~/backups`, checks for recent changes, and writes a summary report to the local logs folder.
- `backup_all.sh`: runs `backup_project.sh` across the projects found under the workspace's `Projects` folder.

## Quick start
1. Make all scripts executable:
   ```bash
   chmod +x backup_all.sh backup_project.sh generate_workspace.sh
   ```
2. Generate the sample workspace:
   ```bash
   ./generate_workspace.sh
   ```
3. Back up a project directory:
   ```bash
   ./backup_project.sh "$PWD/Projects/WebApp"
   ```
4. Run the wrapper to back up every project in the workspace:
   ```bash
   ./backup_all.sh
   ```

## Notes
- `backup_project.sh` saves archives to `~/backups` and writes logs to `./logs/backup_report.txt`.
- The scripts now resolve paths relative to the project directory, so they work on your device without manual path changes.
