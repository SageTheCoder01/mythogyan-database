-- V10__seed_data.sql
-- Initial sample data

INSERT INTO characters (canonical_name, description, type, gender, alignment, attributes, symbolism)
VALUES
('Shiva','Destroyer among Trimurti','Deity','Male','Neutral',
 '{"weapon":"Trishul","mount":"Nandi"}','{"represents":"Destruction and Renewal"}'),
('Parvati','Goddess of love and devotion','Deity','Female','Good',
 '{"mount":"Lion"}','{"represents":"Motherhood"}');

INSERT INTO relationships (source_uuid, target_uuid, relation_type)
SELECT c1.uuid, c2.uuid, 'Consort_of'
FROM characters c1, characters c2
WHERE c1.canonical_name='Shiva' AND c2.canonical_name='Parvati';

INSERT INTO concepts (name, description, category)
VALUES
('Dharma','Righteous duty','Ethical'),
('Karma','Law of cause and effect','Philosophical'),
('Avatar','Divine incarnation','Mythological Archetype');

INSERT INTO entity_concept_tags (entity_uuid, entity_type, concept_uuid, context)
SELECT ch.uuid,'character',co.uuid,'Shiva as embodiment of cosmic renewal'
FROM characters ch, concepts co
WHERE ch.canonical_name='Shiva' AND co.name='Avatar';
