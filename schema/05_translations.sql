-- 05_translations.sql
-- Multilingual field translations for all entities

CREATE TABLE translations (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,          -- character, event, concept
    language_code TEXT NOT NULL,        -- en, hi, ta, etc.
    field_name TEXT NOT NULL,           -- name, description
    translated_text TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(entity_uuid, language_code, field_name)
);
