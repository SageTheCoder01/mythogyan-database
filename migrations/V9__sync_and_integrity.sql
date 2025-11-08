-- V9__sync_and_integrity.sql
-- Graph sync, audit logs, and validation

CREATE TABLE graph_sync_status (
    entity_uuid UUID PRIMARY KEY,
    entity_type TEXT,
    last_synced_at TIMESTAMPTZ,
    sync_status TEXT DEFAULT 'PENDING'
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID,
    entity_type TEXT,
    action TEXT,
    performed_by TEXT,
    timestamp TIMESTAMPTZ DEFAULT now(),
    changes JSONB
);

CREATE VIEW missing_translations AS
SELECT c.uuid, c.canonical_name
FROM characters c
WHERE NOT EXISTS (
    SELECT 1 FROM translations t
    WHERE t.entity_uuid = c.uuid AND t.language_code='hi'
);
