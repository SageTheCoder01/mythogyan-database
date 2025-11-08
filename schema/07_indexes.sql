-- 07_indexes.sql
-- Indexes, search vectors, and triggers

-- JSONB Indexes
CREATE INDEX idx_char_attributes_jsonb ON characters USING GIN (attributes);
CREATE INDEX idx_char_symbolism_jsonb ON characters USING GIN (symbolism);

-- Full Text Search
ALTER TABLE characters ADD COLUMN search_vector tsvector;
UPDATE characters
SET search_vector = to_tsvector('english',
    canonical_name || ' ' || coalesce(description,''));

CREATE INDEX idx_char_search ON characters USING GIN (search_vector);

CREATE FUNCTION trg_characters_search() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english',
     NEW.canonical_name || ' ' || coalesce(NEW.description,''));
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsv_update BEFORE INSERT OR UPDATE
ON characters FOR EACH ROW EXECUTE FUNCTION trg_characters_search();

-- Performance Indexes
CREATE INDEX idx_relationship_source ON relationships(source_uuid);
CREATE INDEX idx_relationship_target ON relationships(target_uuid);
CREATE INDEX idx_event_name ON events(name);
