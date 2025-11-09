-- 10_sync_and_integrity.sql
-- Graph sync tracking, audit logs, and translation/versioning
-- Enhanced for MythoGyan: multilingual, media, reincarnations, artifacts

------------------------------------------------------------
-- 🔁 Graph Sync Status
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS graph_sync_status (
    entity_uuid UUID PRIMARY KEY,
    entity_type TEXT NOT NULL,       -- Character, Event, Concept, Artifact, Media, Reincarnation
    last_synced_at TIMESTAMPTZ,
    sync_status TEXT DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 📝 Audit & Versioning
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entity_history (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,       -- Character, Event, Concept, Artifact, Media
    field_name TEXT NOT NULL,        -- Name of the updated field
    old_value TEXT,
    new_value TEXT,
    changed_by TEXT,
    changed_at TIMESTAMPTZ DEFAULT now()
);

-- Trigger Function to log changes for characters
CREATE OR REPLACE FUNCTION trg_characters_audit() RETURNS trigger AS $$
BEGIN
  IF NEW.* IS DISTINCT FROM OLD.* THEN
    INSERT INTO entity_history(entity_uuid, entity_type, field_name, old_value, new_value, changed_by)
    VALUES(NEW.uuid, 'Character', 'ALL_FIELDS', row_to_json(OLD)::text, row_to_json(NEW)::text, current_user);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_audit_characters
AFTER UPDATE ON characters
FOR EACH ROW
EXECUTE FUNCTION trg_characters_audit();

------------------------------------------------------------
-- 🔍 Missing Translations Check
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_translations AS
SELECT c.uuid AS entity_uuid, c.canonical_name AS entity_name
FROM characters c
WHERE NOT EXISTS (
  SELECT 1 FROM translations t
  WHERE t.entity_uuid = c.uuid
    AND t.language_code = 'hi'
)
UNION
SELECT e.uuid, e.name
FROM events e
WHERE NOT EXISTS (
  SELECT 1 FROM translations t
  WHERE t.entity_uuid = e.uuid
    AND t.language_code = 'hi'
)
UNION
SELECT co.uuid, co.name
FROM concepts co
WHERE NOT EXISTS (
  SELECT 1 FROM translations t
  WHERE t.entity_uuid = co.uuid
    AND t.language_code = 'hi'
)
UNION
SELECT a.uuid, a.name
FROM artifacts a
WHERE NOT EXISTS (
  SELECT 1 FROM translations t
  WHERE t.entity_uuid = a.uuid
    AND t.language_code = 'hi'
)
UNION
SELECT m.uuid, m.url
FROM media m
WHERE NOT EXISTS (
  SELECT 1 FROM translations t
  WHERE t.entity_uuid = m.uuid
    AND t.language_code = 'hi'
);

------------------------------------------------------------
-- 🔗 Additional Integrity Checks
------------------------------------------------------------
-- Ensure reincarnations link valid characters
ALTER TABLE reincarnations
ADD CONSTRAINT fk_prev_char FOREIGN KEY (previous_uuid) REFERENCES characters(uuid),
ADD CONSTRAINT fk_next_char FOREIGN KEY (next_uuid) REFERENCES characters(uuid);

-- Ensure entity_variants link valid base entity
ALTER TABLE entity_variants
ADD CONSTRAINT fk_base_entity FOREIGN KEY (base_entity_uuid) REFERENCES characters(uuid);

-- Ensure events reference valid epochs
ALTER TABLE events
ADD CONSTRAINT fk_epoch FOREIGN KEY (epoch_uuid) REFERENCES epochs(uuid);

-- Ensure artifacts reference valid owner/creator
ALTER TABLE artifacts
ADD CONSTRAINT fk_owner FOREIGN KEY (owner_uuid) REFERENCES characters(uuid),
ADD CONSTRAINT fk_creator FOREIGN KEY (creator_uuid) REFERENCES characters(uuid);
