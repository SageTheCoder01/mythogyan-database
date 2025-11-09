-- 07_indexes.sql
-- Indexes, search vectors, and triggers for MythoGyan (Enhanced)

------------------------------------------------------------
-- 🔹 JSONB Indexes
------------------------------------------------------------
-- Characters
CREATE INDEX IF NOT EXISTS idx_char_attributes_jsonb 
ON characters USING GIN (attributes);

CREATE INDEX IF NOT EXISTS idx_char_symbolism_jsonb 
ON characters USING GIN (symbolism);

-- Artifacts
CREATE INDEX IF NOT EXISTS idx_artifact_variant_details_jsonb
ON artifacts USING GIN (variant_details);

-- Entity Variants
CREATE INDEX IF NOT EXISTS idx_entity_variants_details_jsonb
ON entity_variants USING GIN (variant_details);

------------------------------------------------------------
-- 🔹 Full Text Search
------------------------------------------------------------
-- Characters
ALTER TABLE characters ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE characters
SET search_vector = to_tsvector('english',
    canonical_name || ' ' || coalesce(description,''));

CREATE INDEX IF NOT EXISTS idx_char_search ON characters USING GIN (search_vector);

-- Trigger to auto-update search vector
CREATE OR REPLACE FUNCTION trg_characters_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english',
     NEW.canonical_name || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update BEFORE INSERT OR UPDATE
ON characters FOR EACH ROW EXECUTE FUNCTION trg_characters_search();

------------------------------------------------------------
-- Events
------------------------------------------------------------
ALTER TABLE events ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE events
SET search_vector = to_tsvector('english',
    name || ' ' || coalesce(description,'') || ' ' || coalesce(location,''));

CREATE INDEX IF NOT EXISTS idx_event_search ON events USING GIN (search_vector);

------------------------------------------------------------
-- Concepts
------------------------------------------------------------
ALTER TABLE concepts ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE concepts
SET search_vector = to_tsvector('english',
    name || ' ' || coalesce(description,'') || ' ' || coalesce(category,''));

CREATE INDEX IF NOT EXISTS idx_concept_search ON concepts USING GIN (search_vector);

------------------------------------------------------------
-- Artifacts
------------------------------------------------------------
ALTER TABLE artifacts ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE artifacts
SET search_vector = to_tsvector('english',
    name || ' ' || coalesce(description,'') || ' ' || coalesce(significance,''));

CREATE INDEX IF NOT EXISTS idx_artifact_search ON artifacts USING GIN (search_vector);

------------------------------------------------------------
-- 🔹 Performance Indexes
------------------------------------------------------------
-- Relationships
CREATE INDEX IF NOT EXISTS idx_relationship_source ON relationships(source_uuid);
CREATE INDEX IF NOT EXISTS idx_relationship_target ON relationships(target_uuid);
CREATE INDEX IF NOT EXISTS idx_relationship_type ON relationships(relation_type_uuid);

-- Event Participants
CREATE INDEX IF NOT EXISTS idx_event_participant_char ON event_participants(character_uuid);
CREATE INDEX IF NOT EXISTS idx_event_participant_event ON event_participants(event_uuid);

-- Epochs
CREATE INDEX IF NOT EXISTS idx_epoch_start_event ON epochs(start_event_uuid);
CREATE INDEX IF NOT EXISTS idx_epoch_end_event ON epochs(end_event_uuid);

-- Reincarnations
CREATE INDEX IF NOT EXISTS idx_reincarnation_prev ON reincarnations(previous_uuid);
CREATE INDEX IF NOT EXISTS idx_reincarnation_next ON reincarnations(next_uuid);

-- Entity Variants
CREATE INDEX IF NOT EXISTS idx_entity_variant_base ON entity_variants(base_entity_uuid);

-- Media
CREATE INDEX IF NOT EXISTS idx_media_entity ON media(entity_uuid);
