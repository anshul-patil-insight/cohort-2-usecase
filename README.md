# Automated Project Backup Utility

## 📌 Overview
The **Automated Project Backup Utility** is a robust, Linux-based shell scripting solution designed to standardize and safeguard project backups. Built to replace inconsistent manual backup processes, this utility automates the compression, storage, and logging of project directories. It features a "smart" modification check to save disk space and is fully integrated with Linux `cron` for daily, hands-off execution.

## ✨ Features
* **Smart Backups:** Uses modification timestamps (`mtime`) to skip backups if no files have changed since the last run, conserving disk space.
* **Overwrite Protection:** Automatically detects existing backup archives and appends a Unix timestamp to the filename to prevent accidental data loss.
* **Graceful Error Handling:** Intercepts missing directories and insufficient permissions without crashing, routing errors to a detailed log file instead.
* **Fully Automated Wrapper:** Includes a manager script that dynamically loops through all existing project directories, ensuring newly added projects are automatically backed up without manual configuration.
* **Detailed Logging:** Generates a comprehensive summary report for every backup attempt, logging start/end times, archive sizes, and statuses.

## 📂 File Structure
This project consists of three main shell scripts:

1. `generate_workspace.sh` - **The Sandbox Builder**: Generates a simulated project workspace containing mock code, hidden files, empty directories, and restricted folders to safely test the backup utility.
2. `backup_project.sh` - **The Worker**: The core utility. Accepts a specific project directory as input, performs validation, checks for recent modifications, compresses the folder into a `.tar.gz` archive in `~/backups`, and logs the output.
3. `backup_all.sh` - **The Manager**: An automation wrapper script. Scans the root `Projects` directory and sequentially triggers the worker script for every project it finds.

---

## 🚀 Setup and Installation

**Step 1: Navigate to the directory**
Ensure all three scripts are located in your main working directory (e.g., `~/Automated-Project-Backup-Utility`).

**Step 2: Make the scripts executable**
By default, the text files cannot be run as programs. Grant them execute permissions:
```bash
chmod +x generate_workspace.sh backup_project.sh backup_all.sh
```

**Step 3: Generate the Test Workspace**
Run the generator script to create the mock `Projects` environment for testing:
```bash
./generate_workspace.sh
```

---

## 💻 Usage Instructions

### 1. Manual On-Demand Backup (Single Project)
To manually back up a single, specific project (e.g., right before a major code deployment), run the worker script directly and provide the target path:
```bash
./backup_project.sh ./Projects/WebApp
```

### 2. Manual Full Backup (All Projects)
To instantly trigger a backup of *all* projects inside your `Projects` directory, run the manager script:
```bash
./backup_all.sh
```

### 3. Automating with Cron (Daily Schedule)
To fully automate this process so that it runs every day at 7:00 PM:

1. Open your cron table:
   ```bash
   crontab -e
   ```
2. Add the following line to the bottom of the file (be sure the path matches yours exactly):
   ```bash
   0 19 * * * /Users/audayaku/Automated-Project-Backup-Utility/backup_all.sh
   ```
3. Save and exit. The system will now back up all modified projects automatically in the background.

---

## 📄 Logging and Auditing
Every time a backup is attempted (whether manually or via automation), a summary is appended to a log file located at `./logs/backup_report.txt`. 

You can view the audit trail at any time by running:
```bash
cat logs/backup_report.txt
```
