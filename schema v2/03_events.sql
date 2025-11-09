-- 03_events.sql
-- Enhanced events, participants, hierarchy, epochs, and multilingual readiness

------------------------------------------------------------
-- 🌌 Events
-- Already defined in 01_core_tables.sql
-- This file focuses on views, full-text search, and indexes
------------------------------------------------------------

------------------------------------------------------------
-- 📊 Event Summary View
-- Shows events with participants, roles, and context
------------------------------------------------------------
CREATE OR REPLACE VIEW event_summary AS
SELECT 
    e.uuid AS event_uuid,
    e.name AS event_name,
    e.event_type,
    e.location,
    e.epoch_uuid,
    ep.character_uuid,
    c.canonical_name AS character_name,
    ep.role,
    ep.context AS participant_context,
    e.parent_event_uuid,
    e.start_order,
    e.end_order,
    e.created_at
FROM events e
LEFT JOIN event_participants ep ON ep.event_uuid = e.uuid
LEFT JOIN characters c ON c.uuid = ep.character_uuid;

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_event_name ON events(name);
CREATE INDEX idx_event_epoch ON events(epoch_uuid);
CREATE INDEX idx_event_parent ON events(parent_event_uuid);
CREATE INDEX idx_event_type ON events(event_type);
CREATE INDEX idx_event_participants_event ON event_participants(event_uuid);
CREATE INDEX idx_event_participants_character ON event_participants(character_uuid);

------------------------------------------------------------
-- 🔍 Full Text Search Trigger for Events
------------------------------------------------------------
ALTER TABLE events ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE events
SET search_vector = to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,''));

CREATE FUNCTION trg_events_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.name,'') || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update_events 
BEFORE INSERT OR UPDATE ON events
FOR EACH ROW EXECUTE FUNCTION trg_events_search();

------------------------------------------------------------
-- 🔍 Optional: Missing translations check for events
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_event_translations AS
SELECT e.uuid AS event_uuid,
       e.name AS event_name
FROM events e
LEFT JOIN translations t
  ON t.entity_uuid = e.uuid
 AND t.entity_type = 'event'
WHERE t.id IS NULL;
