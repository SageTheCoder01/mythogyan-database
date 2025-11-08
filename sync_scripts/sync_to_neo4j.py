import psycopg2
from neo4j import GraphDatabase
import os
from datetime import datetime

PG_CONN = os.getenv("PG_CONN")
NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USER = os.getenv("NEO4J_USER")
NEO4J_PASS = os.getenv("NEO4J_PASS")

pg = psycopg2.connect(PG_CONN)
neo = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASS))

def sync_nodes():
    print("🔄 Syncing nodes...")
    cur = pg.cursor()
    cur.execute("SELECT node_id, label, name, description FROM graph_nodes_view;")
    for node_id, label, name, desc in cur.fetchall():
        with neo.session() as s:
            s.run(f"""
                MERGE (n:{label} {{uuid:$uuid}})
                SET n.name=$name, n.description=$desc
            """, uuid=str(node_id), name=name, desc=desc)
    cur.close()
    print("✅ Nodes synced.")

def sync_edges():
    print("🔄 Syncing edges...")
    cur = pg.cursor()
    cur.execute("SELECT source_id, target_id, relation_type FROM graph_edges_view;")
    for src, tgt, rel in cur.fetchall():
        with neo.session() as s:
            s.run(f"""
                MATCH (a {{uuid:$src}}), (b {{uuid:$tgt}})
                MERGE (a)-[r:{rel}]->(b)
            """, src=str(src), tgt=str(tgt))
    cur.close()
    print("✅ Edges synced.")

def log_sync():
    with pg.cursor() as cur:
        cur.execute("""
            INSERT INTO audit_logs (entity_uuid, entity_type, action, performed_by, changes)
            VALUES (gen_random_uuid(), 'sync', 'GraphSync', 'system', '{"status":"complete"}')
        """)
        pg.commit()

if __name__ == "__main__":
    sync_nodes()
    sync_edges()
    log_sync()
    print(f"✅ Graph sync completed at {datetime.now()}")
