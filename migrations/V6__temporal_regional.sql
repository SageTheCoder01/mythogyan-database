-- V6__temporal_regional.sql
-- Epochs, reincarnations, and regional variants

CREATE TABLE epochs (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE,
    order_index INT,
    description TEXT,
    start_event_uuid UUID,
    end_event_uuid UUID
);

CREATE TABLE reincarnations (
    id SERIAL PRIMARY KEY,
    previous_uuid UUID REFERENCES characters(uuid),
    next_uuid UUID REFERENCES characters(uuid),
    cycle_order INT,
    context TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid)
);

CREATE TABLE traditions (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE,
    region TEXT,
    description TEXT
);

CREATE TABLE entity_variants (
    id SERIAL PRIMARY KEY,
    base_entity_uuid UUID NOT NULL,
    variant_name TEXT,
    tradition_uuid UUID REFERENCES traditions(uuid),
    variant_details JSONB,
    source_reference TEXT
);
