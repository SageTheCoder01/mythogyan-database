import psycopg2
from neo4j import GraphDatabase
import os
from datetime import datetime

# Load environment variables
PG_CONN = os.getenv("PG_CONN")
NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USER = os.getenv("NEO4J_USER")
NEO4J_PASS = os.getenv("NEO4J_PASS")

# Connect to PostgreSQL
pg = psycopg2.connect(PG_CONN)

# Connect to Neo4j
neo = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASS))

def sync_nodes():
    print("🔄 Syncing nodes...")
    cur = pg.cursor()
    cur.execute("""
        SELECT node_id, label, name, description, attributes, symbolism
        FROM graph_nodes_view;
    """)
    for node_id, label, name, description, attributes, symbolism in cur.fetchall():
        with neo.session() as s:
            s.run(f"""
                MERGE (n:{label} {{uuid:$uuid}})
                SET n.name=$name,
                    n.description=$description,
                    n.attributes=$attributes,
                    n.symbolism=$symbolism
            """, uuid=str(node_id),
                 name=name,
                 description=description,
                 attributes=attributes,
                 symbolism=symbolism)
    cur.close()
    print("✅ Nodes synced.")

def sync_edges():
    print("🔄 Syncing edges...")
    cur = pg.cursor()
    cur.execute("""
        SELECT edge_id, source_id, target_id, relation_type, metadata, edge_category
        FROM graph_edges_view;
    """)
    for edge_id, source_id, target_id, rel_type, metadata, category in cur.fetchall():
        with neo.session() as s:
            # Make relation type safe for Neo4j
            rel_label = rel_type.replace(" ", "_").upper()
            s.run(f"""
                MATCH (a {{uuid:$src}}), (b {{uuid:$tgt}})
                MERGE (a)-[r:{rel_label}]->(b)
                SET r.metadata=$metadata,
                    r.edge_category=$category,
                    r.uuid=$edge_id
            """, src=str(source_id),
                 tgt=str(target_id),
                 edge_id=str(edge_id),
                 metadata=metadata,
                 category=category)
    cur.close()
    print("✅ Edges synced.")

def log_sync():
    with pg.cursor() as cur:
        cur.execute("""
            INSERT INTO audit_logs (entity_uuid, entity_type, action, performed_by, changes)
            VALUES (gen_random_uuid(), 'sync', 'GraphSync', 'system', '{"status":"complete"}')
        """)
        pg.commit()
    print("📝 Audit log updated.")

if __name__ == "__main__":
    start_time = datetime.now()
    print(f"🚀 Graph sync started at {start_time}")
    sync_nodes()
    sync_edges()
    log_sync()
    end_time = datetime.now()
    print(f"✅ Graph sync completed at {end_time} (Duration: {end_time - start_time})")
