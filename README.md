### `README.md`

# Auto-Notebook-Exporter: Google NotebookLM to Microsoft 365 Copilot

A Dockerized automation tool to migrate your research and notes from Google NotebookLM to Microsoft 365 Copilot Notebooks.

## Features
- **Automated Sanitization**: Converts "Tag Soup" HTML from Google Takeout into clean `.docx` files.
- **Web Remediation**: Authenticated "Print to PDF" for URLs using `undetected-chromedriver`.
- **Smart Consolidation**: Auto-merges files to respect Copilot's 100-file limit.
- **Direct Upload**: Uses Microsoft Graph API to upload processed data directly to OneDrive.
- **Persistent Auth**: Maintains Google and Microsoft sessions across runs.

## Quick Start

1. **Build**
   ```bash
   docker build -t migration-assistant .
   ```

2. **Run**
   ```bash
   docker run -it --rm \
     -v $(pwd)/input:/input \
     -v $(pwd)/output:/output \
     -v $(pwd)/auth_data:/auth_data \
     --cap-add=SYS_ADMIN \
     -e MS_CLIENT_ID="<your-client-id>" \
     migration-assistant
   ```

See [docs/user_guide.md](docs/user_guide.md) for detailed setup and troubleshooting.

**Auto-Notebook-Exporter** is a specialized migration tool built to transition high-value intellectual capital from Google NotebookLM to the Microsoft 365 Copilot ecosystem.

Because Google NotebookLM lacks a direct export API , this toolkit uses "User-Space" automation to extract your notes and sources, transforming them into a structured, "Copilot-ready" format that respects Microsoft’s strict RAG (Retrieval-Augmented Generation) ingestion limits.

## 🏗️ Technical Architecture

The toolkit is designed to be containerized using Docker to ensure all headless browser drivers (Selenium/Chromium) and Python libraries run reliably.

### Core Workflow:

1. 
**Extraction (The "Source Scraper"):** Uses Selenium and BeautifulSoup to scrape text from local HTML exports or live "Source" views.


2. 
**Transformation (The "Sanitizer"):** Strips "tag soup" from HTML and converts content into clean, formatted `.docx` files using `python-docx`.


3. 
**Remediation (Web Gap):** Iterates through a URL list and "Prints to PDF" since Copilot cannot crawl live URLs.


4. 
**Consolidation (The "Merge and Purge"):** Groups small files into consolidated documents to stay under the **100-file limit** and ensures no single file exceeds **145MB**.



## 🚀 Getting Started

### Prerequisites

* Python 3.10+
* Chrome/Chromium (for Selenium)
* Required Libraries: `selenium`, `beautifulsoup4`, `python-docx`, `pdfkit` 



### Installation

```bash
git clone https://github.com/your-username/Auto-Notebook-Exporter.git
cd Auto-Notebook-Exporter
pip install -r requirements.txt

```

### Usage

1. Place your Google Takeout `.zip` or HTML files in the `/raw_data` folder.


2. Run the main automation script:
```bash
python exporter_main.py

```


3. Retrieve your sanitized files from the `/Staging_for_OneDrive` directory.



## 🛠️ Post-Migration: The "Manual Bridge"

Once the script completes, follow these essential manual steps to finalize the "Brain Transplant":

* 
**OneDrive Sync:** Move the `/Staging_for_OneDrive` folder to your Business OneDrive/SharePoint to establish "Live Links".


* 
**Ingestion:** In Microsoft 365 Copilot, create a new Notebook and add the `Master_Export.pdf` as a reference.


* **Grounding Delay:** **Wait 10–15 minutes** before querying. Microsoft needs this "Soak Time" to index the new semantic chunks.



## 📊 Feature Comparison

| Feature | NotebookLM | Copilot Notebooks |
| --- | --- | --- |
| **Ingestion** | Massive Context Window 

 | Semantic Indexing (RAG) 

 |
| **Web Access** | Native URL Crawling 

 | Restricted (Requires PDF) 

 |
| **File Limits** | ~50 sources (soft) 

 | 100 files / 150MB (hard) 

 |
| **Governance** | Personal Sandbox 

 | Sovereign Tenant Boundary 

 |
