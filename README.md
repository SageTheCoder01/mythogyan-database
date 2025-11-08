🕉️ MythoGyan Database

A structured, multilingual knowledge base of Indian mythology — connecting characters, events, relationships, philosophical concepts, and regional traditions through both SQL and graph-based models.

📚 Overview

MythoGyan Database is the central knowledge system powering:

🧠 The MythoGyan Chatbot — conversational mythology assistant

🎮 The MythoGyan Quiz App — knowledge-based learning game

🌐 The MythoGyan Web Platform — browsable digital mythology encyclopedia

It provides:

PostgreSQL for structured relational data

Neo4j for semantic graph exploration

Python Sync Scripts to bridge the two

Flyway Migrations for versioned schema evolution

🧩 Tech Stack
Component	Purpose	Technology
🐘 PostgreSQL	Primary relational database	Open Source
🧠 Neo4j	Graph relationship engine	Open Source
🧭 Flyway	Database version control	Open Source
🐍 Python	Data sync + automation	Open Source
🐳 Docker	Containerized setup	Open Source
📜 Markdown Docs	Data dictionary + ontology	Documentation
🧱 Repository Structure
mythogyan-database/
│
├── 📂 schema/                     # Core schema definitions
│   ├── 01_core_tables.sql
│   ├── 02_relationships.sql
│   ├── 03_events.sql
│   ├── 04_concepts_ontology.sql
│   ├── 05_translations.sql
│   ├── 06_graph_views.sql
│   ├── 07_indexes.sql
│   └── 08_seed_data.sql
│
├── 📂 migrations/                 # Flyway migration scripts
│   ├── V1__init.sql
│   ├── V2__relationships.sql
│   ├── V3__events.sql
│   ├── V4__ontology_and_concepts.sql
│   ├── V5__translations.sql
│   ├── V6__temporal_regional.sql
│   ├── V7__graph_views.sql
│   ├── V8__indexes_and_search.sql
│   ├── V9__sync_and_integrity.sql
│   └── V10__seed_data.sql
│
├── 📂 sync_scripts/               # Neo4j sync automation
│   ├── sync_to_neo4j.py
│   ├── cron_sync.sh
│   ├── config.env
│   └── README.md
│
├── 📂 docs/                       # Developer + schema documentation
│   ├── data_dictionary.md
│   ├── entity_relationships.md
│   ├── ontology_design.md
│   └── schema_diagram.png
│
├── 🐳 docker-compose.yml          # Full stack (Postgres + Neo4j + Flyway)
├── ⚙️  .env                       # Environment configuration
├── 📘 setup_instructions.md       # Step-by-step local setup
├── 📋 developer_onboarding.md     # New developer quick-start checklist
└── 🧭 README.md                   # This file

⚙️ Environment Setup
1️⃣ Clone the Repository
git clone https://github.com/<your-org>/mythogyan-database.git
cd mythogyan-database

2️⃣ Create .env
cp .env.example .env

3️⃣ Update Values
POSTGRES_DB=mythogyan
POSTGRES_USER=mytho_user
POSTGRES_PASSWORD=mytho_pass
POSTGRES_PORT=5432
POSTGRES_HOST=localhost

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASS=neo4jpass

🐳 Run with Docker Compose

Start all services:

docker compose up -d


This launches:

Service	Description	Port
🐘 PostgreSQL	Main knowledge base	5432
🧠 Neo4j	Graph visualization + relationships	7474 / 7687
🧭 Flyway	Schema migrations	—
🔁 Graph Sync	Python data bridge	—

Stop services:

docker compose down

🔍 Verify Setup
PostgreSQL
docker exec -it mythogyan_postgres psql -U mytho_user mythogyan
\dt

Neo4j Browser

Open → http://localhost:7474

Login:

User: neo4j
Pass: neo4jpass


Test query:

MATCH (n) RETURN count(n);

🔁 Graph Sync

Run manually (optional):

cd sync_scripts
export $(grep -v '^#' ../.env | xargs)
python sync_to_neo4j.py


The sync script:

Reads from PostgreSQL views (graph_nodes_view, graph_edges_view)

Pushes data into Neo4j

Logs activity in graph_sync.log

🧩 Schema Highlights
Layer	Tables	Description
Core	characters, relationships, events	Primary mythology entities
Ontology	concepts, concept_hierarchy, entity_concept_tags	Symbolic & philosophical layer
Temporal	epochs, reincarnations	Yuga & reincarnation modeling
Regional	translations, traditions, entity_variants	Multilingual and regional diversity
Graph	graph_views, graph_sync_status	Data ready for Neo4j
Search	indexes, tsvector	Full-text and fuzzy search support
📊 Neo4j Example Queries

Find all avatars of Vishnu:

MATCH (a:Character)-[:AVATAR_OF]->(v:Character {name:'Vishnu'})
RETURN a.name;


Find all entities symbolizing “Dharma”:

MATCH (c:Character)-[:HAS_CONCEPT]->(d:Concept {name:'Dharma'})
RETURN c.name;


Traverse cosmic hierarchy:

MATCH path = (root:Concept {name:'Virtue'})-[:IS_A*]->(child)
RETURN path;

📘 Documentation

📗 Data Dictionary
 — Table definitions and field meanings

🧬 Entity Relationships
 — How entities connect

🪶 Ontology Design
 — Archetypes, roles, and symbolism

🗺️ Schema Diagram
 — ERD view (dbdiagram.io export)

🧱 Development Workflow
Task	Command
Run migrations	docker compose run flyway migrate
Check migration status	docker compose run flyway info
Rebuild containers	docker compose down && docker compose up -d
Access Postgres	docker exec -it mythogyan_postgres psql -U mytho_user mythogyan
Access Neo4j Browser	http://localhost:7474

Run sync manually	python sync_scripts/sync_to_neo4j.py
🚀 Production Notes
Aspect	Recommendation
Database	Use managed PostgreSQL (AWS RDS / Supabase)
Graph	Host Neo4j AuraDB (free tier available)
Backups	Daily dumps for Postgres and Neo4j
Migrations	Run via CI/CD with Flyway
Sync	Schedule via cron or systemd
Security	Never commit .env; rotate credentials monthly
🧠 Project Vision

The MythoGyan Knowledge Base is designed to be:

📚 A structured mythology ontology for India’s diverse traditions

🧠 A reasoning layer for AI models and chatbots

🎨 A flexible base for quiz, web, and educational apps

🌍 Multilingual and culturally inclusive

👥 Contributing

We welcome contributors!

Fork the repo

Create a feature branch

Add or modify a migration (e.g., V11__add_media_table.sql)

Test locally

Submit a PR with a clear description

🛡️ License

MIT License — Open Source.
Use freely for educational and non-commercial projects.

💬 Contact

MythoGyan Dev Team
📧 mythogyan.team@gmail.com

🌐 https://mythogyan.org
 (placeholder)

🕉️ “Preserving ancient wisdom through modern data.”