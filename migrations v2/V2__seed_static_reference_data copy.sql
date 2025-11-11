-- ================================================================
-- 🕉️ MythoGyan Knowledge Base
-- Version: V2__seed_static_reference_data.sql
-- Description: Static mythological constants and reusable references
-- Author: Mythogyan Dev Team
-- ================================================================

-- ================================================================
-- 🌺 EPOCHS & YUGAS
-- ================================================================
INSERT INTO epochs (uuid, name, order_index, description, yuga_type)
VALUES
  (gen_random_uuid(), 'Satya Yuga', 1, 'Age of Truth and Purity — Dharma stands firm on all four pillars.', 'Krita'),
  (gen_random_uuid(), 'Treta Yuga', 2, 'Age of Sacrifice and Virtue — decline of Dharma begins.', 'Treta'),
  (gen_random_uuid(), 'Dvapara Yuga', 3, 'Age of Duality and Ritualism — moral confusion grows.', 'Dvapara'),
  (gen_random_uuid(), 'Kali Yuga', 4, 'Age of Darkness and Ignorance — final phase of the cosmic cycle.', 'Kali');

-- ================================================================
-- 📚 SCRIPTURES
-- ================================================================
INSERT INTO scriptures (uuid, name, type, description, estimated_period, cultural_region, language)
VALUES
  (gen_random_uuid(), 'Rig Veda', 'Veda', 'Oldest of the four Vedas, hymns dedicated to deities like Agni, Indra, and Soma.', '1500–1200 BCE', 'Vedic India', 'Sanskrit'),
  (gen_random_uuid(), 'Yajur Veda', 'Veda', 'Covers liturgical formulas used in ritual sacrifices.', '1200 BCE', 'Vedic India', 'Sanskrit'),
  (gen_random_uuid(), 'Sama Veda', 'Veda', 'Collection of chants and melodies for Soma rituals.', '1200 BCE', 'Vedic India', 'Sanskrit'),
  (gen_random_uuid(), 'Atharva Veda', 'Veda', 'Contains spells, charms, and philosophical hymns.', '1000 BCE', 'Vedic India', 'Sanskrit'),
  (gen_random_uuid(), 'Ramayana', 'Itihasa', 'Epic composed by Valmiki narrating the life of Lord Rama.', '500 BCE', 'Ayodhya Region', 'Sanskrit'),
  (gen_random_uuid(), 'Mahabharata', 'Itihasa', 'Epic by Vyasa centered around the Kurukshetra War and Dharma.', '400 BCE', 'Northern India', 'Sanskrit'),
  (gen_random_uuid(), 'Bhagavad Gita', 'Upanishad', 'Philosophical dialogue between Krishna and Arjuna in the Mahabharata.', '400 BCE', 'Kurukshetra', 'Sanskrit'),
  (gen_random_uuid(), 'Shiva Purana', 'Purana', 'One of the major Puranas dedicated to Lord Shiva.', '400 CE', 'Pan-Indian', 'Sanskrit'),
  (gen_random_uuid(), 'Vishnu Purana', 'Purana', 'Describes avatars and cosmic functions of Vishnu.', '500 CE', 'Pan-Indian', 'Sanskrit'),
  (gen_random_uuid(), 'Bhagavata Purana', 'Purana', 'Devotional text narrating Krishna’s divine play (Leela).', '800 CE', 'Pan-Indian', 'Sanskrit');

-- ================================================================
-- ⚔️ WEAPONS CATALOG
-- ================================================================
INSERT INTO weapons_catalog (uuid, name, description, weapon_type, elemental_affinity)
VALUES
  (gen_random_uuid(), 'Sudarshana Chakra', 'Divine discus wielded by Lord Vishnu. Represents cosmic order.', 'Astra', 'Light'),
  (gen_random_uuid(), 'Brahmastra', 'Weapon created by Brahma, capable of immense destruction.', 'Astra', 'Fire'),
  (gen_random_uuid(), 'Pashupatastra', 'Weapon of Shiva that can destroy any being, used by Arjuna.', 'Astra', 'Cosmic'),
  (gen_random_uuid(), 'Trishula', 'Trident of Lord Shiva symbolizing creation, maintenance, and destruction.', 'Shastra', 'Cosmic'),
  (gen_random_uuid(), 'Gada of Bhima', 'Mace representing physical strength and righteousness.', 'Shastra', 'Earth'),
  (gen_random_uuid(), 'Sharanga Bow', 'Celestial bow of Lord Vishnu gifted by Varuna.', 'Shastra', 'Wind');

INSERT INTO weapon_traits (weapon_uuid, trait_name, trait_value)
VALUES
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Sudarshana Chakra'), 'Deity Association', 'Vishnu'),
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Sudarshana Chakra'), 'Power', 'Universal Balance'),
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Brahmastra'), 'Power', 'Ultimate Destruction'),
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Brahmastra'), 'Requires Invocation', 'True Knowledge of Brahma'),
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Pashupatastra'), 'Granted By', 'Shiva'),
  ((SELECT uuid FROM weapons_catalog WHERE name = 'Pashupatastra'), 'Power', 'Cosmic Dissolution');

-- ================================================================
-- 💫 CHARACTERISTICS
-- ================================================================
INSERT INTO characteristics (uuid, name, description, category, polarity)
VALUES
  (gen_random_uuid(), 'Valor', 'Bravery in the face of danger, moral courage.', 'Virtue', 'Positive'),
  (gen_random_uuid(), 'Wisdom', 'Knowledge coupled with good judgment.', 'Virtue', 'Positive'),
  (gen_random_uuid(), 'Compassion', 'Empathy and kindness toward all beings.', 'Virtue', 'Positive'),
  (gen_random_uuid(), 'Ego', 'Inflated self-importance and pride.', 'Vice', 'Negative'),
  (gen_random_uuid(), 'Wrath', 'Anger leading to destructive outcomes.', 'Vice', 'Negative'),
  (gen_random_uuid(), 'Devotion', 'Faithful surrender to divine or moral ideals.', 'Virtue', 'Positive');

-- ================================================================
-- 🔱 CONCEPTS & ARCHETYPES
-- ================================================================
INSERT INTO concepts (uuid, name, description, category, ethical_polarity, archetype, symbolic_color, cultural_region)
VALUES
  (gen_random_uuid(), 'Dharma', 'Moral and cosmic law sustaining the universe.', 'Ethical Principle', 'Positive', 'Order', 'Gold', 'Pan-Indian'),
  (gen_random_uuid(), 'Karma', 'Principle of cause and effect guiding moral actions.', 'Metaphysical Law', 'Neutral', 'Cycle', 'Bronze', 'Pan-Indian'),
  (gen_random_uuid(), 'Maya', 'Illusion that veils true reality.', 'Philosophical Concept', 'Neutral', 'Deception', 'Silver', 'Pan-Indian'),
  (gen_random_uuid(), 'Bhakti', 'Path of devotion and surrender to the divine.', 'Spiritual Path', 'Positive', 'Love', 'Blue', 'Pan-Indian'),
  (gen_random_uuid(), 'Adharma', 'Unrighteousness opposing the natural order.', 'Ethical Principle', 'Negative', 'Chaos', 'Black', 'Pan-Indian');

-- ================================================================
-- 🌌 MYTHOLOGICAL CYCLES
-- ================================================================
INSERT INTO mythological_cycles (uuid, name, type, order_index, duration_years, description)
VALUES
  (gen_random_uuid(), 'Svayambhuva Manvantara', 'Manvantara', 1, 306720000, 'First Manvantara ruled by Svayambhuva Manu.'),
  (gen_random_uuid(), 'Vaivasvata Manvantara', 'Manvantara', 7, 306720000, 'Current Manvantara under Vaivasvata Manu.'),
  (gen_random_uuid(), 'Shvetavaraha Kalpa', 'Kalpa', 1, 4320000000, 'Current day of Brahma known as the White Boar Kalpa.');

-- ================================================================
-- 📘 SCRIPTURE SECTIONS (Samples)
-- ================================================================
INSERT INTO scripture_sections (uuid, scripture_uuid, section_name, reference_code, summary)
VALUES
  (gen_random_uuid(), (SELECT uuid FROM scriptures WHERE name = 'Bhagavad Gita'), 'Arjuna Vishada Yoga', '1.1–1.47', 'Despair of Arjuna before battle.'),
  (gen_random_uuid(), (SELECT uuid FROM scriptures WHERE name = 'Bhagavad Gita'), 'Sankhya Yoga', '2.1–2.72', 'Krishna teaches the nature of the self.'),
  (gen_random_uuid(), (SELECT uuid FROM scriptures WHERE name = 'Bhagavad Gita'), 'Karma Yoga', '3.1–3.43', 'Path of selfless action.'),
  (gen_random_uuid(), (SELECT uuid FROM scriptures WHERE name = 'Ramayana'), 'Bala Kanda', '1–5', 'Birth of Rama and his early life.'),
  (gen_random_uuid(), (SELECT uuid FROM scriptures WHERE name = 'Mahabharata'), 'Bhishma Parva', '6', 'The great Kurukshetra war begins.');

-- ================================================================
-- ✅ SUMMARY COMMENT
-- ================================================================
-- This static data represents universal, reusable constants.
-- These entities can be linked by dynamic records like characters, events, and relationships.
-- Example:
-- - Rama → primary_scripture_uuid → (SELECT uuid FROM scriptures WHERE name = 'Ramayana')
-- - Arjuna → weapon_uuid → (SELECT uuid FROM weapons_catalog WHERE name = 'Gandiva Bow')
-- - Events → epoch_uuid → (SELECT uuid FROM epochs WHERE name = 'Treta Yuga')
