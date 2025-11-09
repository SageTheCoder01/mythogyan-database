# 🔁 MythoGyan — Graph Sync Automation

This folder contains everything needed to keep your **PostgreSQL knowledge base** in sync with **Neo4j**, powering relationship queries, lineage graphs, and concept maps.

---

## 📂 Files Overview

| File | Description |
|------|--------------|
| `sync_to_neo4j.py` | Main Python script that pushes nodes & edges |
| `sync_config.env` | Database and environment configuration |
| `cron_sync.sh` | Optional script for scheduled sync |
| `README.md` | This documentation file |

---

## 🧰 Prerequisites

| Tool | Version | Purpose |
|------|----------|----------|
| PostgreSQL | ≥ 15 | Knowledge base |
| Neo4j | ≥ 5.x | Graph database |
| Python | ≥ 3.9 | Script runtime |
| Pip libs | `psycopg2-binary`, `neo4j`, `python-dotenv` | Connections |

Install dependencies:
```bash
pip install psycopg2-binary neo4j python-dotenv
