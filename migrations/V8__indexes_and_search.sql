-- V8__indexes_and_search.sql
-- Indexes and full-text search vectors

CREATE INDEX idx_char_attributes_jsonb ON characters USING GIN (attributes);
CREATE INDEX idx_char_symbolism_jsonb ON characters USING GIN (symbolism);

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
