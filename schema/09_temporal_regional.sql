-- 09_temporal_regional.sql
-- Temporal (Yuga) & regional variant modeling

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

CREATE TABLE event_timeline (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid),
    epoch_uuid UUID REFERENCES epochs(uuid),
    start_order INT,
    end_order INT,
    is_cyclical BOOLEAN DEFAULT false
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
