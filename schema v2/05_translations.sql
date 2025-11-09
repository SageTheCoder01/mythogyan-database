-- 05_translations.sql
-- Multilingual translations for all entities in MythoGyan
-- Future-ready with fallback support and missing translations check

------------------------------------------------------------
-- 🌐 Translations Table
------------------------------------------------------------
CREATE TABLE translations (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,             -- Links to any entity (character, artifact, event, concept, text, relationship)
    entity_type TEXT NOT NULL,             -- Entity type, e.g., 'character', 'event', 'concept', 'artifact', 'text', 'relationship'
    language_code TEXT NOT NULL,           -- Language code, e.g., 'en', 'hi', 'ta'
    field_name TEXT NOT NULL,              -- Field being translated, e.g., 'canonical_name', 'description', 'role', 'significance', 'content', 'context'
    translated_text TEXT NOT NULL,         -- The translation itself
    is_fallback BOOLEAN DEFAULT FALSE,     -- TRUE if this is default language
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(entity_uuid, language_code, field_name)
);

------------------------------------------------------------
-- 📊 View: Missing Translations
-- Shows entities missing translations for a specific language
------------------------------------------------------------
CREATE OR REPLACE VIEW missing_translations AS
SELECT 
    t.entity_uuid,
    t.entity_type,
    t.field_name
FROM (
    SELECT 'character' AS entity_type, uuid AS entity_uuid, 'canonical_name' AS field_name FROM characters
    UNION ALL
    SELECT 'character', uuid, 'description' FROM characters
    UNION ALL
    SELECT 'event', uuid, 'name' FROM events
    UNION ALL
    SELECT 'event', uuid, 'description' FROM events
    UNION ALL
    SELECT 'concept', uuid, 'name' FROM concepts
    UNION ALL
    SELECT 'concept', uuid, 'description' FROM concepts
    UNION ALL
    SELECT 'artifact', uuid, 'name' FROM artifacts
    UNION ALL
    SELECT 'artifact', uuid, 'description' FROM artifacts
    UNION ALL
    SELECT 'text', uuid, 'title' FROM texts
    UNION ALL
    SELECT 'text', uuid, 'content' FROM texts
    UNION ALL
    SELECT 'relationship', uuid, 'context' FROM relationships
) t
WHERE NOT EXISTS (
    SELECT 1 
    FROM translations tr
    WHERE tr.entity_uuid = t.entity_uuid
      AND tr.entity_type = t.entity_type
      AND tr.field_name = t.field_name
      AND tr.language_code = 'hi' -- Example: check for Hindi translation
);

------------------------------------------------------------
-- 📈 Indexes for Performance
------------------------------------------------------------
CREATE INDEX idx_translations_entity ON translations(entity_uuid);
CREATE INDEX idx_translations_entity_field ON translations(entity_uuid, field_name);
CREATE INDEX idx_translations_language ON translations(language_code);
