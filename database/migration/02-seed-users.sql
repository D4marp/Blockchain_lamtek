-- Test users for LAM Teknik (password for all: Test1234!)
SET @pw = '$2b$10$lPhKjUB5p.6JKV2UtGoM4e.Z4aYEwyS7Y7QH7mvymYkQGvZFKCTEK';

INSERT INTO users (name, nama, email, password, role, isActive, is_active)
VALUES
  ('Admin LAM Teknik',      'Admin LAM Teknik',      'admin@lamtek.test',       @pw, 'ADMIN',           1, 1),
  ('Sekretariat LAM',       'Sekretariat LAM',       'sekretariat@lamtek.test', @pw, 'SEKRETARIAT',     1, 1),
  ('Komite Evaluasi',       'Komite Evaluasi',       'komite@lamtek.test',      @pw, 'KOMITE_EVALUASI', 1, 1),
  ('Majelis Akreditasi',    'Majelis Akreditasi',    'majelis@lamtek.test',     @pw, 'MAJELIS_AKREDITASI', 1, 1),
  ('Asesor Satu',           'Asesor Satu',           'asesor@lamtek.test',      @pw, 'ASESOR',          1, 1),
  ('Validator Satu',        'Validator Satu',        'validator@lamtek.test',   @pw, 'VALIDATOR',       1, 1),
  ('Prodi Demo',            'Prodi Demo',            'prodi@lamtek.test',       @pw, 'PRODI',           1, 1),
  ('UPPS Demo',             'UPPS Demo',             'upps@lamtek.test',        @pw, 'UPPS',            1, 1)
ON DUPLICATE KEY UPDATE password = VALUES(password), isActive = 1, is_active = 1;

SELECT id, name, email, role, isActive FROM users ORDER BY id;
