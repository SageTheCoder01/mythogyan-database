-- ================================================================
-- 🕉️ MythoGyan Knowledge Base
-- Version: V3__sample_characters_and_events.sql
-- Description: Core mythological sample entities (characters, events, relationships)
-- Author: Mythogyan Dev Team
-- ================================================================

-- ================================================================
-- 🧠 CHARACTERS
-- ================================================================
INSERT INTO characters (uuid, canonical_name, description, type, gender, alignment, origin, primary_scripture_uuid)
VALUES
  (gen_random_uuid(), 'Vishnu', 'Preserver and protector of the universe, one of the Trimurti.', 'Deity', 'Male', 'Good', 'Cosmic', (SELECT uuid FROM scriptures WHERE name = 'Vishnu Purana')),
  (gen_random_uuid(), 'Shiva', 'The destroyer and transformer among the Trimurti.', 'Deity', 'Male', 'Neutral', 'Kailasha', (SELECT uuid FROM scriptures WHERE name = 'Shiva Purana')),
  (gen_random_uuid(), 'Brahma', 'The creator god and source of all knowledge.', 'Deity', 'Male', 'Neutral', 'Cosmic', (SELECT uuid FROM scriptures WHERE name = 'Rig Veda')),
  (gen_random_uuid(), 'Lakshmi', 'Goddess of wealth, prosperity, and fortune.', 'Deity', 'Female', 'Good', 'Cosmic', (SELECT uuid FROM scriptures WHERE name = 'Vishnu Purana')),
  (gen_random_uuid(), 'Parvati', 'Consort of Shiva and goddess of fertility and power.', 'Deity', 'Female', 'Good', 'Kailasha', (SELECT uuid FROM scriptures WHERE name = 'Shiva Purana')),
  (gen_random_uuid(), 'Rama', 'Seventh avatar of Vishnu, hero of the Ramayana.', 'Avatar', 'Male', 'Good', 'Ayodhya', (SELECT uuid FROM scriptures WHERE name = 'Ramayana')),
  (gen_random_uuid(), 'Sita', 'Consort of Rama, embodiment of virtue and devotion.', 'Human', 'Female', 'Good', 'Mithila', (SELECT uuid FROM scriptures WHERE name = 'Ramayana')),
  (gen_random_uuid(), 'Hanuman', 'Devotee of Rama, known for strength and loyalty.', 'Vanara', 'Male', 'Good', 'Kishkindha', (SELECT uuid FROM scriptures WHERE name = 'Ramayana')),
  (gen_random_uuid(), 'Ravana', 'King of Lanka, devotee of Shiva, antagonist in Ramayana.', 'Rakshasa', 'Male', 'Evil', 'Lanka', (SELECT uuid FROM scriptures WHERE name = 'Ramayana')),
  (gen_random_uuid(), 'Arjuna', 'Pandava prince, disciple of Krishna, warrior of Dharma.', 'Human', 'Male', 'Good', 'Indraprastha', (SELECT uuid FROM scriptures WHERE name = 'Mahabharata')),
  (gen_random_uuid(), 'Krishna', 'Eighth avatar of Vishnu, divine strategist and teacher of Gita.', 'Avatar', 'Male', 'Good', 'Mathura', (SELECT uuid FROM scriptures WHERE name = 'Bhagavad Gita'));

-- ================================================================
-- 🕰️ EVENTS
-- ================================================================
INSERT INTO events (uuid, name, description, epoch_uuid, event_type)
VALUES
  (gen_random_uuid(), 'Kurukshetra War', 'Epic war between Pandavas and Kauravas symbolizing Dharma vs Adharma.', 
    (SELECT uuid FROM epochs WHERE name = 'Dvapara Yuga'), 'Battle'),
  (gen_random_uuid(), 'Coronation of Rama', 'Return and coronation of Lord Rama after vanquishing Ravana.', 
    (SELECT uuid FROM epochs WHERE name = 'Treta Yuga'), 'Coronation'),
  (gen_random_uuid(), 'Abduction of Sita', 'Event where Ravana abducts Sita, triggering the great war.', 
    (SELECT uuid FROM epochs WHERE name = 'Treta Yuga'), 'Conflict');

-- ================================================================
-- ⚔️ BATTLES
-- ================================================================
INSERT INTO battles (uuid, name, description, epoch_uuid, location_uuid, outcome)
VALUES
  (gen_random_uuid(), 'Battle of Lanka', 'The climactic battle between Rama and Ravana.', 
    (SELECT uuid FROM epochs WHERE name = 'Treta Yuga'), NULL, 'Victory of Rama'),
  (gen_random_uuid(), 'Kurukshetra War', 'The Mahabharata war of Dharma vs Adharma.',
    (SELECT uuid FROM epochs WHERE name = 'Dvapara Yuga'), NULL, 'Victory of Pandavas');

-- ================================================================
-- ⚔️ BATTLE PARTICIPANTS
-- ================================================================
INSERT INTO battle_participants (battle_uuid, character_uuid, role, side, context)
VALUES
  ((SELECT uuid FROM battles WHERE name = 'Battle of Lanka'), (SELECT uuid FROM characters WHERE canonical_name = 'Rama'), 'Commander', 'Righteous', 'Led the Vanara army.'),
  ((SELECT uuid FROM battles WHERE name = 'Battle of Lanka'), (SELECT uuid FROM characters WHERE canonical_name = 'Ravana'), 'Commander', 'Rakshasa', 'Defended Lanka.'),
  ((SELECT uuid FROM battles WHERE name = 'Battle of Lanka'), (SELECT uuid FROM characters WHERE canonical_name = 'Hanuman'), 'General', 'Righteous', 'Key warrior who burned Lanka.'),
  ((SELECT uuid FROM battles WHERE name = 'Kurukshetra War'), (SELECT uuid FROM characters WHERE canonical_name = 'Arjuna'), 'Archer', 'Pandava', 'Guided by Krishna.'),
  ((SELECT uuid FROM battles WHERE name = 'Kurukshetra War'), (SELECT uuid FROM characters WHERE canonical_name = 'Krishna'), 'Charioteer', 'Pandava', 'Divine guide and teacher of Dharma.');

-- ================================================================
-- 🔱 RELATIONSHIPS
-- ================================================================
INSERT INTO relationship_types (uuid, name, description, category)
VALUES
  (gen_random_uuid(), 'Consort', 'Spouse or divine counterpart', 'Familial'),
  (gen_random_uuid(), 'Avatar Of', 'Incarnation of a higher being', 'Spiritual'),
  (gen_random_uuid(), 'Devotee Of', 'Follower or worshipper relationship', 'Spiritual'),
  (gen_random_uuid(), 'Ally', 'Supportive relationship in battle or cause', 'Social');

INSERT INTO relationships (uuid, source_uuid, target_uuid, relation_type_uuid, context)
VALUES
  (gen_random_uuid(), (SELECT uuid FROM characters WHERE canonical_name = 'Lakshmi'), (SELECT uuid FROM characters WHERE canonical_name = 'Vishnu'),
   (SELECT uuid FROM relationship_types WHERE name = 'Consort'), 'Eternal consort across incarnations.'),
  (gen_random_uuid(), (SELECT uuid FROM characters WHERE canonical_name = 'Parvati'), (SELECT uuid FROM characters WHERE canonical_name = 'Shiva'),
   (SELECT uuid FROM relationship_types WHERE name = 'Consort'), 'Embodiment of Shakti and consciousness union.'),
  (gen_random_uuid(), (SELECT uuid FROM characters WHERE canonical_name = 'Rama'), (SELECT uuid FROM characters WHERE canonical_name = 'Vishnu'),
   (SELECT uuid FROM relationship_types WHERE name = 'Avatar Of'), 'Seventh incarnation of Vishnu in Treta Yuga.'),
  (gen_random_uuid(), (SELECT uuid FROM characters WHERE canonical_name = 'Krishna'), (SELECT uuid FROM characters WHERE canonical_name = 'Vishnu'),
   (SELECT uuid FROM relationship_types WHERE name = 'Avatar Of'), 'Eighth incarnation of Vishnu in Dvapara Yuga.'),
  (gen_random_uuid(), (SELECT uuid FROM characters WHERE canonical_name = 'Hanuman'), (SELECT uuid FROM characters WHERE canonical_name = 'Rama'),
   (SELECT uuid FROM relationship_types WHERE name = 'Devotee Of'), 'Embodiment of devotion (Bhakti) and strength.');

-- ================================================================
-- 🪶 CONCEPT TAGS (Symbolism and Archetypes)
-- ================================================================
INSERT INTO entity_concept_tags (entity_uuid, entity_type, concept_uuid, relevance_score, context)
VALUES
  ((SELECT uuid FROM characters WHERE canonical_name = 'Rama'), 'Character', (SELECT uuid FROM concepts WHERE name = 'Dharma'), 0.95, 'Embodiment of righteousness.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Krishna'), 'Character', (SELECT uuid FROM concepts WHERE name = 'Karma'), 0.9, 'Teacher of selfless action.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Hanuman'), 'Character', (SELECT uuid FROM concepts WHERE name = 'Bhakti'), 1.0, 'Pure devotion.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Ravana'), 'Character', (SELECT uuid FROM concepts WHERE name = 'Adharma'), 0.85, 'Misuse of knowledge.');

-- ================================================================
-- 💫 CHARACTERISTICS (Virtues & Traits)
-- ================================================================
INSERT INTO entity_characteristics (entity_uuid, entity_type, characteristic_uuid, intensity_score, context)
VALUES
  ((SELECT uuid FROM characters WHERE canonical_name = 'Rama'), 'Character', (SELECT uuid FROM characteristics WHERE name = 'Valor'), 0.95, 'Righteous warrior king.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Rama'), 'Character', (SELECT uuid FROM characteristics WHERE name = 'Wisdom'), 0.9, 'Just ruler.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Krishna'), 'Character', (SELECT uuid FROM characteristics WHERE name = 'Wisdom'), 1.0, 'Teacher of Gita.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Hanuman'), 'Character', (SELECT uuid FROM characteristics WHERE name = 'Devotion'), 1.0, 'Bhakti personified.'),
  ((SELECT uuid FROM characters WHERE canonical_name = 'Ravana'), 'Character', (SELECT uuid FROM characteristics WHERE name = 'Ego'), 0.95, 'Overconfidence leading to downfall.');

-- ================================================================
-- 🗺️ LOCATIONS
-- ================================================================
INSERT INTO locations (uuid, name, historical_name, type, description, current_country)
VALUES
  (gen_random_uuid(), 'Ayodhya', 'Kosala', 'City', 'Capital of Rama, land of virtue.', 'India'),
  (gen_random_uuid(), 'Kishkindha', NULL, 'Region', 'Kingdom of Sugriva and Vanaras.', 'India'),
  (gen_random_uuid(), 'Lanka', NULL, 'Island', 'Golden kingdom of Ravana.', 'Sri Lanka'),
  (gen_random_uuid(), 'Kurukshetra', NULL, 'Battlefield', 'Site of the Mahabharata war.', 'India');

-- ================================================================
-- ✅ SUMMARY
-- ================================================================
-- This dataset introduces:
--   - 11 core characters
--   - 3 sample events
--   - 2 major battles
--   - 5 relationships
--   - 4 concept tags
--   - 5 sets of characteristics
--   - Reusable constants from V2 (Yugas, Scriptures, Weapons, etc.)
-- Ideal for testing graph queries, chatbot responses, and multilingual support.
