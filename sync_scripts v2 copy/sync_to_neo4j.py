#!/usr/bin/env python3
# ================================================================
# 🕉️ MythoGyan Knowledge Base — Neo4j Sync Script
# ------------------------------------------------
# Cross-platform version (Windows, macOS, Linux)
# Auto-loads .env configs, syncs PostgreSQL graph data to Neo4j
# Author: Mythogyan Dev Team
# ================================================================

import os
import sys
import logging
import psycopg2
from psycopg2.extras import RealDictCursor
from neo4j import GraphDatabase
from datetime import datetime
from dotenv import load_dotenv

# ================================================================
# LOAD ENVIRONMENT VARIABLES
# ================================================================
# Automatically load variables from .env or sync_config.env
if os.path.exists("sync_config.env"):
    load_dotenv(dotenv_path="sync_config.env")
else:
    load_dotenv()  # fallback to .env if present

# ================================================================
# CONFIGURATION
# ================================================================
POSTGRES_DSN = os.getenv("PG_CONN", "dbname=mythogyan user=mytho_user password=mytho_pass host=localhost port=5432")
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASS = os.getenv("NEO4J_PASS", "neo4jpass")
LOG_FILE = os.getenv("LOG_FILE", "graph_sync.log")
SYNC_MODE = os.getenv("SYNC_MODE", "FULL").upper()

# ================================================================
# LOGGER SETUP
# ================================================================
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
console = logging.StreamHandler(sys.stdout)
console.setLevel(logging.INFO)
logging.getLogger().addHandler(console)

def log(msg):
    logging.info(msg)
    print(msg)

# ================================================================
# POSTGRESQL FETCHING FUNCTIONS
# ================================================================
def fetch_data(query):
    try:
        conn = psycopg2.connect(POSTGRES_DSN)
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(query)
            return cur.fetchall()
    except Exception as e:
        log(f"❌ PostgreSQL error: {e}")
        return []
    finally:
        if 'conn' in locals():
            conn.close()

def get_nodes():
    log("📦 Fetching graph nodes from PostgreSQL...")
    return fetch_data("SELECT * FROM graph_nodes_view;")

def get_edges():
    log("🔗 Fetching graph edges from PostgreSQL...")
    return fetch_data("SELECT * FROM graph_edges_view;")

# ================================================================
# NEO4J HANDLER
# ================================================================
class Neo4jSync:
    def __init__(self, uri, user, password):
        try:
            self.driver = GraphDatabase.driver(uri, auth=(user, password))
            # Quick test connection
            with self.driver.session() as session:
                session.run("RETURN 1")
            log(f"✅ Connected to Neo4j at {uri}")
        except Exception as e:
            log(f"❌ Cannot connect to Neo4j: {e}")
            self.driver = None

    def close(self):
        if self.driver:
            self.driver.close()

    def sync_nodes(self, nodes):
        if not self.driver:
            log("⚠️ Skipping node sync (Neo4j unavailable).")
            return
        if not nodes:
            log("⚠️ No nodes to sync.")
            return

        log(f"⬆️ Syncing {len(nodes)} nodes to Neo4j...")
        query = """
        UNWIND $rows AS row
        MERGE (n {uuid: row.node_id})
        SET n.name = row.name,
            n.type = row.node_type,
            n.subtype = row.subtype,
            n.alignment = row.alignment,
            n.gender = row.gender,
            n.origin = row.origin,
            n.symbolism = row.symbolism,
            n.attributes = row.attributes,
            n.created_at = row.created_at,
            n.updated_at = row.updated_at
        """
        with self.driver.session() as session:
            session.run(query, rows=nodes)
        log("✅ Nodes sync complete.")

    def sync_edges(self, edges):
        if not self.driver:
            log("⚠️ Skipping edge sync (Neo4j unavailable).")
            return
        if not edges:
            log("⚠️ No relationships to sync.")
            return

        log(f"🔄 Syncing {len(edges)} relationships to Neo4j...")
        query = """
        UNWIND $rows AS row
        MATCH (a {uuid: row.source_id})
        MATCH (b {uuid: row.target_id})
        MERGE (a)-[r:RELATION {uuid: row.edge_id}]->(b)
        SET r.type = row.edge_type,
            r.context = row.context,
            r.confidence = row.confidence_score,
            r.created_at = row.created_at
        """
        with self.driver.session() as session:
            session.run(query, rows=edges)
        log("✅ Relationships sync complete.")

# ================================================================
# SYNC EXECUTION
# ================================================================
def perform_sync():
    log("🚀 Starting Neo4j synchronization...")

    nodes = get_nodes()
    edges = get_edges()

    neo4j = Neo4jSync(NEO4J_URI, NEO4J_USER, NEO4J_PASS)

    try:
        neo4j.sync_nodes(nodes)
        neo4j.sync_edges(edges)
        log("🎉 Graph synchronization successful.")
    except Exception as e:
        log(f"❌ Sync failed: {e}")
    finally:
        neo4j.close()

    log("🕊️ Sync process completed.\n")

# ================================================================
# ENTRY POINT
# ================================================================
if __name__ == "__main__":
    start = datetime.now()
    log(f"===== MythoGyan Graph Sync Started at {start} =====")

    mode = SYNC_MODE
    if mode == "FULL":
        log("Running FULL sync (all nodes and edges).")
        perform_sync()
    elif mode == "INCREMENTAL":
        log("Running INCREMENTAL sync (based on last_synced_at — not yet implemented).")
        perform_sync()
    else:
        log(f"⚠️ Unknown SYNC_MODE: {mode}, defaulting to FULL.")
        perform_sync()

    end = datetime.now()
    log(f"===== Sync Completed at {end} | Duration: {end - start} =====")
