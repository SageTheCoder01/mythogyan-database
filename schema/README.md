🧱 MythoGyan Knowledge Base — Database Schema Guide

📂 Folder: /schema/
🗃️ Database: PostgreSQL 16+
🔄 Graph Mirror: Neo4j (via sync script)

⚙️ Overview

This folder contains the complete Knowledge Base schema for the MythoGyan ecosystem — the single source of truth for:

📜 Mythological characters, artifacts, texts

🧭 Ontological classifications (concepts, archetypes)

⏳ Temporal cycles (Yugas, reincarnations)

🌍 Regional and linguistic variants

🧩 Relationship graph (Neo4j integration)

Each .sql file is modular for version control, but all can be merged for a full bootstrap setup.

🧩 File Structure
File	Description	Run Order
01_core_tables.sql	Base entities — characters, texts, artifacts	1️⃣
02_relationships.sql	Relationships between characters/entities	2️⃣
03_events.sql	Events and participant mapping	3️⃣
04_concepts_ontology.sql	Semantic ontology, concepts, and tagging	4️⃣
05_translations.sql	Multilingual translation support	5️⃣
09_temporal_regional.sql	Epochs, reincarnations, regional variants	6️⃣
06_graph_views.sql	Views for graph export to Neo4j	7️⃣
07_indexes.sql	JSONB indexes, search vectors, triggers	8️⃣
10_sync_and_integrity.sql	Graph sync tracking + audit + validation views	9️⃣
08_seed_data.sql	Initial data for testing	🔟

🧠 You can also merge them all into one file using scripts/build_schema.sh.

🚀 Quick Setup
1️⃣ Run Locally (psql CLI)
psql -U mytho_user -d mythogyan -f schema/01_core_tables.sql
psql -U mytho_user -d mythogyan -f schema/02_relationships.sql
psql -U mytho_user -d mythogyan -f schema/03_events.sql
psql -U mytho_user -d mythogyan -f schema/04_concepts_ontology.sql
psql -U mytho_user -d mythogyan -f schema/05_translations.sql
psql -U mytho_user -d mythogyan -f schema/09_temporal_regional.sql
psql -U mytho_user -d mythogyan -f schema/06_graph_views.sql
psql -U mytho_user -d mythogyan -f schema/07_indexes.sql
psql -U mytho_user -d mythogyan -f schema/10_sync_and_integrity.sql
psql -U mytho_user -d mythogyan -f schema/08_seed_data.sql

2️⃣ Run via Docker Compose

In your root docker-compose.yml:

services:
  postgres:
    image: postgres:16
    container_name: mythogyan_postgres
    environment:
      POSTGRES_DB: mythogyan
      POSTGRES_USER: mytho_user
      POSTGRES_PASSWORD: mytho_pass
    ports:
      - "5432:5432"
    volumes:
      - ./schema:/docker-entrypoint-initdb.d


✅ PostgreSQL automatically loads all .sql files from /schema when the container starts.

🔗 Neo4j Graph Sync
Purpose

MythoGyan mirrors relationships and ontology into Neo4j for faster graph traversal queries.

Sync Script

File: /sync_scripts/sync_to_neo4j.py

How it works:

Reads nodes from graph_nodes_view

Reads edges from graph_edges_view

Creates/updates nodes and relationships in Neo4j

Run manually:

export PG_CONN="dbname=mythogyan user=postgres password=mytho_pass host=localhost"
python sync_scripts/sync_to_neo4j.py


✅ Verify results in Neo4j Browser
Example query:

MATCH (n:Character)-[r]->(m) RETURN n, r, m LIMIT 25;

🧩 Key Design Principles
Principle	Description
UUID Everywhere	Ensures consistent referencing across SQL, APIs, Neo4j
JSONB Fields	Store flexible attributes (powers, mounts, meanings)
Views for Sync	graph_nodes_view / graph_edges_view act as graph APIs
Semantic Tags	Concepts → tie mythological ideas to characters/events
Cyclical Time	Epoch & reincarnation tables represent Yugas
Regionalism	Variants linked via entity_variants
Multilingual	translations table handles any field in any language
🧠 Verification Checklist
Task	Command	Status
Check tables exist	\dt	☐
Verify sample data	SELECT * FROM characters;	☐
View graph nodes	SELECT * FROM graph_nodes_view LIMIT 10;	☐
Verify search index	\d+ characters (check search_vector)	☐
Neo4j sync test	Run sync script	☐
🧰 Maintenance Guidelines

Schema changes: always create a new .sql file with next version (e.g., 11_new_feature.sql)

Production migration: use Flyway or Liquibase to apply ordered migrations

Backup:

pg_dump -Fc mythogyan > backups/mythogyan_$(date +%F).dump


Full rebuild:

psql -U mytho_user -d mythogyan -f build/mythogyan_full_schema.sql

🧾 References

PostgreSQL Docs → https://www.postgresql.org/docs/

Neo4j Docs → https://neo4j.com/docs/

pgAdmin → https://www.pgadmin.org/