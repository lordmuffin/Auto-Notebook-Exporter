# Migration Assistant User Guide

## Overview
This tool automates the migration of your Google NotebookLM data to Microsoft 365 Copilot Notebooks. It handles:
- **Extraction**: Converting HTML exports to clean Word documents.
- **Web Remediation**: safely "printing" URLs to PDF using an authenticated browser session.
- **Consolidation**: Merging files to ensure you stay within Copilot's 100-file/150MB limits.
- **Upload**: Automatically uploading the staged files to your OneDrive.

## Prerequisites
- **Docker Desktop** installed and running.
- **Google Account** (source data).
- **Microsoft 365 Account** (destination).
- **Input Data**: A Google Takeout Zip file or a folder of HTML files, and optionally a `urls.txt` file.

## Setup & Usage

### 1. Pre-requisites
Ensure you have a directory ready for input (e.g., `~/migration/input`) containing your Takeout zip or `urls.txt`.
Create a directory for the output `~/migration/output`.
Create a directory for persistent authentication data `~/migration/auth_data`.

### 2. Building the Image
Open your terminal in the project directory and run:

```bash
docker build -t migration-assistant .
```

### 3. Running the Migration
Run the container with the following command. Note the volume mounts which are critical for saving your login sessions.

```bash
docker run -it --rm \
  -v ~/migration/input:/input \
  -v ~/migration/output:/output \
  -v ~/migration/auth_data:/auth_data \
  --cap-add=SYS_ADMIN \
  migration-assistant
```

> **Note**: `--cap-add=SYS_ADMIN` is often required for Chrome in Docker.

### 4. Authentication Process
**First Run:**
- **Google**: The tool will attempt to launch a browser. Since this is running in Docker, you might see logs about `undetected_chromedriver`. If it cannot launch a GUI, it uses a persistent profile in `/auth_data`.
  - *Tip*: For the very first run, if you encounter bot detection blocks, you may need to run the `undetected_chromedriver` locally on your machine pointing to the same profile path, login once, and then move that profile folder to `~/migration/auth_data`.
- **Microsoft**: The tool will print a **Device Code** to the console (e.g., `A1B2C3D4`).
  - Go to [microsoft.com/devicelogin](https://microsoft.com/devicelogin).
  - Enter the code.
  - Sign in with your Work/School account.
  - The tool will detect the login and proceed.

### 5. Integration
Once finished, the tool will report:
> "Migration Phase 1 Complete. Your data has been AUTOMATICALLY uploaded to your OneDrive..."

Go to **Microsoft 365 Copilot > Notebooks** and add the files from your OneDrive `Staging_for_OneDrive` folder.

## Troubleshooting

### "Browser crashes immediately"
Ensure you are passing `--cap-add=SYS_ADMIN` to the `docker run` command.

### "Google Login fails"
Google has strict bot detection. If `undetected_chromedriver` inside Docker fails:
1. Run the script locally (outside Docker) once with the same `auth_data` path:
   ```bash
   pip install -r requirements.txt
   python migration_assistant.py
   ```
2. Login to Google.
3. Once the profile is populated in `auth_data`, use that same folder for the Docker volume.

### "Upload fails"
Check your internet connection and ensure your Microsoft account has permissions to write to OneDrive.
