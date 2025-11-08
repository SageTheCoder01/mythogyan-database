-- V5__translations.sql
-- Multilingual translation layer

CREATE TABLE translations (
    id SERIAL PRIMARY KEY,
    entity_uuid UUID NOT NULL,
    entity_type TEXT NOT NULL,
    language_code TEXT NOT NULL,
    field_name TEXT NOT NULL,
    translated_text TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(entity_uuid, language_code, field_name)
);
