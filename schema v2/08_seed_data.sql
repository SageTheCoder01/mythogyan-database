-- 08_seed_data.sql
-- Starter mythological dataset for MythoGyan (Enhanced)

------------------------------------------------------------
-- 🌟 Characters
------------------------------------------------------------
INSERT INTO characters (canonical_name, description, type, gender, alignment, attributes, symbolism)
VALUES
('Shiva','Destroyer among Trimurti','Deity','Male','Neutral',
 '{"weapon":"Trishul","mount":"Nandi"}','{"represents":"Destruction and Renewal"}'),
('Parvati','Goddess of love and devotion, consort of Shiva','Deity','Female','Good',
 '{"mount":"Lion"}','{"represents":"Motherhood"}'),
('Ganesha','Son of Shiva and Parvati, remover of obstacles','Deity','Male','Good',
 '{"vehicle":"Mouse"}','{"represents":"Wisdom and Success"}');

------------------------------------------------------------
-- 🌐 Relationship Types
------------------------------------------------------------
INSERT INTO relationship_types (name, description, category)
VALUES
('Consort','Married/partner relationship','Familial'),
('Father','Parent-child relationship','Familial'),
('Mother','Parent-child relationship','Familial'),
('Avatar','Divine incarnation','Divine');

------------------------------------------------------------
-- 🔗 Relationships
------------------------------------------------------------
-- Shiva & Parvati consort
INSERT INTO relationships (source_uuid, target_uuid, relation_type_uuid, confidence_score, is_bidirectional)
SELECT s.uuid, p.uuid, rt.uuid, 1.0, TRUE
FROM characters s, characters p, relationship_types rt
WHERE s.canonical_name='Shiva' AND p.canonical_name='Parvati' AND rt.name='Consort';

-- Shiva father of Ganesha
INSERT INTO relationships (source_uuid, target_uuid, relation_type_uuid)
SELECT s.uuid, g.uuid, rt.uuid
FROM characters s, characters g, relationship_types rt
WHERE s.canonical_name='Shiva' AND g.canonical_name='Ganesha' AND rt.name='Father';

-- Parvati mother of Ganesha
INSERT INTO relationships (source_uuid, target_uuid, relation_type_uuid)
SELECT p.uuid, g.uuid, rt.uuid
FROM characters p, characters g, relationship_types rt
WHERE p.canonical_name='Parvati' AND g.canonical_name='Ganesha' AND rt.name='Mother';

------------------------------------------------------------
-- 📜 Events
------------------------------------------------------------
INSERT INTO events (name, description, epoch_uuid, location, start_order, end_order, event_type)
VALUES
('Marriage of Shiva and Parvati','Divine wedding in Kailash',NULL,'Kailash',1,1,'Marriage'),
('Birth of Ganesha','Birth of Ganesha, son of Shiva and Parvati',NULL,'Kailash',2,2,'Birth');

-- Event Participants
INSERT INTO event_participants (event_uuid, character_uuid, role)
SELECT e.uuid, c.uuid, 'Participant'
FROM events e, characters c
WHERE e.name='Marriage of Shiva and Parvati' AND c.canonical_name IN ('Shiva','Parvati');

INSERT INTO event_participants (event_uuid, character_uuid, role)
SELECT e.uuid, c.uuid, 'Participant'
FROM events e, characters c
WHERE e.name='Birth of Ganesha' AND c.canonical_name IN ('Shiva','Parvati','Ganesha');

------------------------------------------------------------
-- 🪔 Artifacts
------------------------------------------------------------
INSERT INTO artifacts (name, description, material, owner_uuid, creator_uuid, significance)
SELECT 'Trishul','Trident of Shiva','Steel',s.uuid,s.uuid,'Symbol of Destruction and Renewal'
FROM characters s WHERE s.canonical_name='Shiva';

INSERT INTO artifacts (name, description, material, owner_uuid, creator_uuid, significance)
SELECT 'Lion Mount','Parvati''s Lion Mount','Organic',p.uuid,p.uuid,'Vehicle of Goddess Parvati'
FROM characters p WHERE p.canonical_name='Parvati';

------------------------------------------------------------
-- 🎨 Concepts
------------------------------------------------------------
INSERT INTO concepts (name, description, category)
VALUES
('Dharma','Righteous duty','Ethical'),
('Karma','Law of cause and effect','Philosophical'),
('Avatar','Divine incarnation','Mythological Archetype');

-- Concept Tags
INSERT INTO entity_concept_tags (entity_uuid, entity_type, concept_uuid, context)
SELECT ch.uuid,'character',co.uuid,'Shiva embodies cosmic renewal'
FROM characters ch, concepts co
WHERE ch.canonical_name='Shiva' AND co.name='Avatar';

------------------------------------------------------------
-- ⏳ Epochs & Reincarnations
------------------------------------------------------------
INSERT INTO epochs (name, order_index, description, yuga_type)
VALUES
('Treta Yuga',1,'Second Yuga after Satya','Treta');

-- Reincarnation example
INSERT INTO reincarnations (previous_uuid, next_uuid, cycle_order, context)
SELECT s1.uuid, s2.uuid, 1, 'Shiva reincarnates as Rudra'
FROM characters s1, characters s2
WHERE s1.canonical_name='Shiva' AND s2.canonical_name='Shiva';

------------------------------------------------------------
-- 🌏 Traditions & Entity Variants
------------------------------------------------------------
INSERT INTO traditions (name, region, description)
VALUES
('Shaiva','North India','Shiva-centric tradition'),
('Shakta','South India','Parvati-centric tradition');

INSERT INTO entity_variants (base_entity_uuid, variant_name, tradition_uuid)
SELECT c.uuid,'Mahadeva',t.uuid FROM characters c, traditions t
WHERE c.canonical_name='Shiva' AND t.name='Shaiva';

INSERT INTO entity_variants (base_entity_uuid, variant_name, tradition_uuid)
SELECT c.uuid,'Uma','Shakta',t.uuid FROM characters c, traditions t
WHERE c.canonical_name='Parvati' AND t.name='Shakta';

------------------------------------------------------------
-- 🎥 Media
------------------------------------------------------------
INSERT INTO media (entity_uuid, entity_type, media_type, url, caption)
SELECT c.uuid,'Character','Image','https://example.com/shiva.jpg','Shiva image'
FROM characters c WHERE c.canonical_name='Shiva';

INSERT INTO media (entity_uuid, entity_type, media_type, url, caption)
SELECT c.uuid,'Character','Image','https://example.com/parvati.jpg','Parvati image'
FROM characters c WHERE c.canonical_name='Parvati';

------------------------------------------------------------
-- 🌐 Translations (English default)
------------------------------------------------------------
INSERT INTO translations (entity_uuid, entity_type, language_code, field_name, translated_text, is_fallback)
SELECT c.uuid,'character','en','canonical_name',c.canonical_name,TRUE
FROM characters c;

INSERT INTO translations (entity_uuid, entity_type, language_code, field_name, translated_text, is_fallback)
SELECT e.uuid,'event','en','name',e.name,TRUE
FROM events e;

INSERT INTO translations (entity_uuid, entity_type, language_code, field_name, translated_text, is_fallback)
SELECT co.uuid,'concept','en','name',co.name,TRUE
FROM concepts co;
