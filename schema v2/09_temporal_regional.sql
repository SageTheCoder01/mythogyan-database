-- 09_temporal_regional.sql
-- Temporal (Yuga) & Regional Variant Modeling — Enhanced for MythoGyan

------------------------------------------------------------
-- ⏳ Epochs / Yugas
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS epochs (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    order_index INT,
    description TEXT,
    yuga_type TEXT,                -- Satya, Treta, Dvapara, Kali
    start_event_uuid UUID REFERENCES events(uuid),
    end_event_uuid UUID REFERENCES events(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🔁 Reincarnations
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reincarnations (
    id SERIAL PRIMARY KEY,
    previous_uuid UUID REFERENCES characters(uuid),
    next_uuid UUID REFERENCES characters(uuid),
    cycle_order INT,
    context TEXT,
    epoch_uuid UUID REFERENCES epochs(uuid),
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🕰️ Event Timeline
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS event_timeline (
    id SERIAL PRIMARY KEY,
    event_uuid UUID REFERENCES events(uuid) ON DELETE CASCADE,
    epoch_uuid UUID REFERENCES epochs(uuid),
    start_order INT,            -- chronological order within the epoch
    end_order INT,
    is_cyclical BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🌏 Traditions
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS traditions (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    region TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🌐 Entity Variants
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS entity_variants (
    id SERIAL PRIMARY KEY,
    base_entity_uuid UUID NOT NULL,
    variant_name TEXT NOT NULL,
    tradition_uuid UUID REFERENCES traditions(uuid),
    variant_details JSONB,
    source_reference TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

------------------------------------------------------------
-- 🔗 Update Characters with Birth/Death Events
------------------------------------------------------------
ALTER TABLE characters
ADD COLUMN IF NOT EXISTS birth_event_uuid UUID REFERENCES events(uuid);

ALTER TABLE characters
ADD COLUMN IF NOT EXISTS death_event_uuid UUID REFERENCES events(uuid);

------------------------------------------------------------
-- 🔗 Sample Seed: Link Characters to Events & Epochs
------------------------------------------------------------
-- Example: Shiva & Parvati
UPDATE characters
SET birth_event_uuid = e.uuid
FROM events e
WHERE e.name = 'Marriage of Shiva and Parvati'
AND characters.canonical_name = 'Shiva';

UPDATE characters
SET birth_event_uuid = e.uuid
FROM events e
WHERE e.name = 'Marriage of Shiva and Parvati'
AND characters.canonical_name = 'Parvati';

-- Event Timeline Example
INSERT INTO event_timeline (event_uuid, epoch_uuid, start_order, end_order, is_cyclical)
SELECT e.uuid, ep.uuid, 1, 1, FALSE
FROM events e
JOIN epochs ep ON ep.name = 'Treta Yuga'
WHERE e.name IN ('Marriage of Shiva and Parvati');

INSERT INTO event_timeline (event_uuid, epoch_uuid, start_order, end_order, is_cyclical)
SELECT e.uuid, ep.uuid, 2, 2, FALSE
FROM events e
JOIN epochs ep ON ep.name = 'Treta Yuga'
WHERE e.name IN ('Birth of Ganesha');
