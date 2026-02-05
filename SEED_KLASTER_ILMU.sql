-- Seed Klaster Ilmu (Science Field Classifications)
-- 11 engineering and professional clusters

INSERT INTO klaster_ilmu (kode_klaster, nama_klaster, deskripsi, is_active, created_at, updated_at) VALUES
('TS', 'Teknik Sipil', 'Bidang studi yang mempelajari perencanaan, perancangan, pelaksanaan, dan pemeliharaan konstruksi bangunan dan infrastruktur', 1, NOW(), NOW()),
('TE', 'Teknik Elektro', 'Bidang studi yang mempelajari aplikasi praktis dari elektrisitas, elektronika, dan elektromagnetisme', 1, NOW(), NOW()),
('TM', 'Teknik Mesin', 'Bidang studi yang mempelajari perancangan, manufaktur, instalasi, dan pengoperasian mesin-mesin', 1, NOW(), NOW()),
('TI', 'Teknik Industri', 'Bidang studi yang mempelajari optimalisasi sistem, proses, dan manajemen dalam industri', 1, NOW(), NOW()),
('TK', 'Teknik Kimia', 'Bidang studi yang mempelajari proses kimia dalam skala industri dan produksi bahan kimia', 1, NOW(), NOW()),
('TL', 'Teknik Lingkungan', 'Bidang studi yang mempelajari pengelolaan lingkungan dan sumber daya alam berkelanjutan', 1, NOW(), NOW()),
('TP', 'Teknik Pertambangan', 'Bidang studi yang mempelajari eksplorasi, ekstraksi, dan pengolahan bahan tambang', 1, NOW(), NOW()),
('TG', 'Teknik Geologi', 'Bidang studi yang mempelajari struktur bumi, mineral, dan aplikasinya dalam industri', 1, NOW(), NOW()),
('TGD', 'Teknik Geodesi', 'Bidang studi yang mempelajari pemetaan dan pengukuran permukaan bumi serta informasi geografis', 1, NOW(), NOW()),
('TMT', 'Teknik Material', 'Bidang studi yang mempelajari struktur, sifat, dan penggunaan material dalam berbagai aplikasi teknik', 1, NOW(), NOW()),
('PI', 'Profesi Insinyur', 'Bidang studi yang mempersiapkan lulusan untuk menjadi profesional insinyur bersertifikat', 1, NOW(), NOW());

-- Verify insertion
SELECT COUNT(*) as total_klaster_ilmu FROM klaster_ilmu;
SELECT * FROM klaster_ilmu ORDER BY kode_klaster;
