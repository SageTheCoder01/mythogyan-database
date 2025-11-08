🧭 MythoGyan Database — Setup Instructions

Version: 1.0
Author: MythoGyan Dev Team
Last Updated: November 2025

🌍 Overview

This guide walks you through setting up the MythoGyan Knowledge Base, which powers:

🧠 The chatbot (MythoGyan Assistant)

🎮 The quiz app

🌐 The web version

It includes:

PostgreSQL — relational knowledge base

Neo4j — semantic graph layer

Flyway — database migrations

Sync Scripts — bridge between SQL and graph data

🧱 1️⃣ Prerequisites
Tool	Version	Description
Docker	≥ 24.x	Container platform
Docker Compose	≥ v2	Multi-container orchestration
Git	≥ 2.35	Repo version control
Python	≥ 3.9	For sync scripts (optional local use)
Flyway (optional)	≥ 10.x	DB migrations runner

Check versions:

docker -v
docker compose version
git --version

📦 2️⃣ Clone the Repository
git clone https://github.com/<your-org>/mythogyan-database.git
cd mythogyan-database

⚙️ 3️⃣ Environment Configuration
1. Copy .env template
cp .env.example .env

2. Edit .env with your local values

Example:

POSTGRES_DB=mythogyan
POSTGRES_USER=mytho_user
POSTGRES_PASSWORD=mytho_pass
POSTGRES_PORT=5432
POSTGRES_HOST=localhost

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASS=neo4jpass

🐳 4️⃣ Run All Services with Docker

Start everything:

docker compose up -d


This will launch:

Service	Port	Description
PostgreSQL	5432	Main knowledge base
Neo4j	7474 (HTTP), 7687 (Bolt)	Graph database & browser
Flyway	—	Runs all DB migrations
Graph Sync	—	Optional auto-sync from SQL → Neo4j
🔍 5️⃣ Verify the Setup
🐘 PostgreSQL

Access database shell:

docker exec -it mythogyan_postgres psql -U mytho_user mythogyan


List tables:

\dt

🧠 Neo4j

Visit the Neo4j browser:
👉 http://localhost:7474

Login:

User: neo4j
Pass: neo4jpass


Test a query:

MATCH (n) RETURN count(n);

🧩 6️⃣ Running Migrations Manually (Optional)

If you need to re-run or verify migrations:

docker compose run flyway migrate


View migration history:

docker compose run flyway info

🔁 7️⃣ Run Graph Sync Script (Local or Docker)
Option A — Inside Docker (auto from compose)

Already handled by the graphsync service in docker-compose.yml.

Option B — Manual run (local dev)
cd sync_scripts
export $(grep -v '^#' ../.env | xargs)
python sync_to_neo4j.py


This will:

Read data from PostgreSQL

Push characters, events, and concepts into Neo4j

Log output in graph_sync.log

🧾 8️⃣ Folder Overview
Folder	Purpose
/schema	Core SQL table definitions
/migrations	Versioned Flyway migration scripts
/sync_scripts	Python bridge for Neo4j sync
/docs	Data dictionary, ontology, and schema diagram
.env	Environment variables
docker-compose.yml	Container orchestration
setup_instructions.md	This file
🧱 9️⃣ Common Developer Commands
Task	Command
Rebuild all containers	docker compose down && docker compose up -d
View logs	docker compose logs -f
Stop all	docker compose down
Access Postgres	docker exec -it mythogyan_postgres psql -U mytho_user mythogyan
Access Neo4j Browser	http://localhost:7474
Run sync manually	python sync_scripts/sync_to_neo4j.py
Re-run migrations	docker compose run flyway migrate
🧠 10️⃣ Troubleshooting
Issue	Cause	Fix
database "mythogyan" does not exist	Postgres not initialized	Restart Docker Compose
Neo4j connection refused	Port conflict	Ensure 7474/7687 are free
Migrations fail	SQL error	Check /migrations order or syntax
Sync fails	Neo4j auth or URI issue	Verify NEO4J_URI and credentials
🔒 11️⃣ Security Tips

Never commit .env to Git (add it to .gitignore)

Use different .env files per environment:

.env.dev

.env.prod

Rotate Neo4j and DB passwords regularly

Run production DBs behind SSL or VPN

🚀 12️⃣ Deployment Notes

For production:

Change .env with production credentials

Use an external Postgres and Neo4j host (not local containers)

Disable APP_DEBUG

Schedule sync script via cron_sync.sh or systemd

🧩 Optional Enhancements
Enhancement	Description
systemd service	Run sync after reboot
Backup scripts	Regular DB dumps
Neo4j Bloom / GraphQL	For visualization
ElasticSearch	Future fuzzy query integration
Read replicas	For scaling quiz and chatbot read queries
✅ Quick Recap

Clone repo

Configure .env

Run docker compose up -d

Access:

PostgreSQL → port 5432

Neo4j Browser → http://localhost:7474

Verify data → psql / Neo4j

(Optional) Run sync manually

🎉 You’re ready to develop, explore, and extend MythoGyan Knowledge Base!