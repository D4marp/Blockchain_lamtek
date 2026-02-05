-- Seed Master Data untuk Registrasi Akreditasi

-- 1. Seed Institusi
INSERT INTO institusi (kode_institusi, nama_institusi, jenis_pt, provinsi_id, alamat, kota, telepon, email, website, status, is_active, created_at, updated_at) VALUES
('UNIV001', 'Universitas Indonesia', 'PTN', 1, 'Jl. Margonda Raya', 'Depok', '021-7270000', 'rektorat@ui.ac.id', 'www.ui.ac.id', 'AKTIF', 1, NOW(), NOW()),
('UNIV002', 'Institut Teknologi Bandung', 'PTN', 2, 'Jl. Ganesha 10', 'Bandung', '0274-513220', 'rektorat@itb.ac.id', 'www.itb.ac.id', 'AKTIF', 1, NOW(), NOW()),
('UNIV003', 'Universitas Sumatera Utara', 'PTN', 3, 'Jl. Universitas No. 19', 'Medan', '061-8213737', 'rektorat@usu.ac.id', 'www.usu.ac.id', 'AKTIF', 1, NOW(), NOW()),
('UNIV004', 'Universitas Pendidikan Indonesia', 'PTN', 2, 'Jl. Dr. Setiabudi 229', 'Bandung', '0274-200066', 'rektorat@upi.edu', 'www.upi.edu', 'AKTIF', 1, NOW(), NOW()),
('UNIV005', 'Universitas Airlangga', 'PTN', 4, 'Kampus A Jl. Mulyorejo', 'Surabaya', '031-5033000', 'rektorat@unair.ac.id', 'www.unair.ac.id', 'AKTIF', 1, NOW(), NOW());

-- 2. Seed Jenjang
INSERT INTO jenjang (kode, nama, tingkat, is_active, created_at, updated_at) VALUES
('D3', 'Diploma 3', 1, 1, NOW(), NOW()),
('D4', 'Diploma 4', 2, 1, NOW(), NOW()),
('S1', 'Sarjana (S1)', 3, 1, NOW(), NOW()),
('S2', 'Magister (S2)', 4, 1, NOW(), NOW()),
('S3', 'Doktor (S3)', 5, 1, NOW(), NOW()),
('PROFESI', 'Program Profesi', 6, 1, NOW(), NOW());

-- 3. Seed UPPS (Fakultas/Jurusan)
INSERT INTO upps (institusi_id, kode, nama, tipe, alamat, telepon, email, is_active, created_at, updated_at) VALUES
(1, 'FTUI001', 'Fakultas Teknik', 'FAKULTAS', 'Kampus UI Depok', '021-7270001', 'dekan.ft@ui.ac.id', 1, NOW(), NOW()),
(1, 'FMIPUI01', 'Fakultas Matematika dan Ilmu Pengetahuan Alam', 'FAKULTAS', 'Kampus UI Depok', '021-7270002', 'dekan.fmip@ui.ac.id', 1, NOW(), NOW()),
(1, 'FHUI0001', 'Fakultas Hukum', 'FAKULTAS', 'Kampus UI Depok', '021-7270003', 'dekan.fh@ui.ac.id', 1, NOW(), NOW()),
(2, 'FTITB001', 'Fakultas Teknik', 'FAKULTAS', 'Kampus ITB Bandung', '0274-513221', 'dekan.ft@itb.ac.id', 1, NOW(), NOW()),
(2, 'FSRITB01', 'Fakultas Seni Rupa dan Desain', 'FAKULTAS', 'Kampus ITB Bandung', '0274-513222', 'dekan.fsrd@itb.ac.id', 1, NOW(), NOW()),
(3, 'FTUMSU01', 'Fakultas Teknik', 'FAKULTAS', 'Kampus USU Medan', '061-8213738', 'dekan.ft@usu.ac.id', 1, NOW(), NOW()),
(4, 'FTUPI001', 'Fakultas Teknik', 'FAKULTAS', 'Kampus UPI Bandung', '0274-200067', 'dekan.ft@upi.edu', 1, NOW(), NOW()),
(5, 'FTUNAIR1', 'Fakultas Teknik', 'FAKULTAS', 'Kampus Unair', '031-5033001', 'dekan.ft@unair.ac.id', 1, NOW(), NOW());

-- 4. Seed Program Studi
INSERT INTO prodi (upps_id, jenjang_id, kode, nama, akreditasi_sebelumnya, status, is_active, created_at, updated_at) VALUES
-- UI Teknik
(1, 3, 'TEKNIK-INFORMATIKA', 'Teknik Informatika', 'A', 'AKTIF', 1, NOW(), NOW()),
(1, 3, 'TEKNIK-SIPIL', 'Teknik Sipil', 'A', 'AKTIF', 1, NOW(), NOW()),
(1, 3, 'TEKNIK-MESIN', 'Teknik Mesin', 'B', 'AKTIF', 1, NOW(), NOW()),
(1, 4, 'TEKNIK-INFORMATIKA-S2', 'Teknik Informatika (S2)', 'A', 'AKTIF', 1, NOW(), NOW()),
-- UI FMIPA
(2, 3, 'MATEMATIKA', 'Matematika', 'A', 'AKTIF', 1, NOW(), NOW()),
(2, 3, 'FISIKA', 'Fisika', 'B', 'AKTIF', 1, NOW(), NOW()),
-- UI FH
(3, 3, 'ILMU-HUKUM', 'Ilmu Hukum', 'A', 'AKTIF', 1, NOW(), NOW()),
(3, 4, 'HUKUM-S2', 'Ilmu Hukum (S2)', 'A', 'AKTIF', 1, NOW(), NOW()),
-- ITB FT
(4, 3, 'TEKNIK-INDUSTRI-ITB', 'Teknik Industri', 'A', 'AKTIF', 1, NOW(), NOW()),
(4, 3, 'TEKNIK-KIMIA-ITB', 'Teknik Kimia', 'A', 'AKTIF', 1, NOW(), NOW()),
(4, 4, 'ENGINEERING-S2', 'Engineering (S2)', 'A', 'AKTIF', 1, NOW(), NOW()),
-- ITB FSRD
(5, 3, 'DESAIN-KOMUNIKASI-VISUAL', 'Desain Komunikasi Visual', 'B', 'AKTIF', 1, NOW(), NOW()),
(5, 3, 'DESAIN-INTERIOR', 'Desain Interior', 'B', 'AKTIF', 1, NOW(), NOW()),
-- USU FT
(6, 3, 'TEKNIK-ELEKTRO-USU', 'Teknik Elektro', 'B', 'AKTIF', 1, NOW(), NOW()),
(6, 1, 'TEKNIK-SIPIL-D3', 'Teknik Sipil (D3)', 'B', 'AKTIF', 1, NOW(), NOW()),
-- UPI FT
(7, 3, 'PENDIDIKAN-TEKNIK-MESIN', 'Pendidikan Teknik Mesin', 'B', 'AKTIF', 1, NOW(), NOW()),
(7, 4, 'PENDIDIKAN-TEKNIK-MESIN-S2', 'Pendidikan Teknik Mesin (S2)', 'B', 'AKTIF', 1, NOW(), NOW()),
-- UNAIR FT
(8, 3, 'TEKNIK-PERKAPALAN', 'Teknik Perkapalan', 'B', 'AKTIF', 1, NOW(), NOW()),
(8, 2, 'TEKNIK-LISTRIK-D4', 'Teknik Listrik (D4)', 'B', 'AKTIF', 1, NOW(), NOW());

-- 5. Seed Skema Pembayaran
INSERT INTO skema_pembayaran (kode, nama, deskripsi, harga_reguler, harga_pjj, status, is_active, created_at, updated_at) VALUES
('SKM001', 'Skema Pembayaran Reguler S1', 'Skema pembayaran untuk akreditasi reguler program S1', 5000000, 3000000, 'AKTIF', 1, NOW(), NOW()),
('SKM002', 'Skema Pembayaran Reguler S2', 'Skema pembayaran untuk akreditasi reguler program S2', 7500000, 5000000, 'AKTIF', 1, NOW(), NOW()),
('SKM003', 'Skema Pembayaran Reguler S3', 'Skema pembayaran untuk akreditasi reguler program S3', 10000000, 7500000, 'AKTIF', 1, NOW(), NOW()),
('SKM004', 'Skema Pembayaran Reguler D3', 'Skema pembayaran untuk akreditasi reguler program D3', 3500000, 2500000, 'AKTIF', 1, NOW(), NOW()),
('SKM005', 'Skema Pembayaran Reguler D4', 'Skema pembayaran untuk akreditasi reguler program D4', 4500000, 3000000, 'AKTIF', 1, NOW(), NOW());

-- 6. Seed Bank
INSERT INTO bank (kode, nama, nomor_rekening, atas_nama, status, is_active, created_at, updated_at) VALUES
('BRI', 'Bank Rakyat Indonesia', '0123456789', 'LAM-Teknik', 'AKTIF', 1, NOW(), NOW()),
('BCA', 'Bank Central Asia', '9876543210', 'LAM-Teknik', 'AKTIF', 1, NOW(), NOW()),
('MANDIRI', 'Bank Mandiri', '1234567890', 'LAM-Teknik', 'AKTIF', 1, NOW(), NOW()),
('BTN', 'Bank Tabungan Negara', '5678901234', 'LAM-Teknik', 'AKTIF', 1, NOW(), NOW());

-- Verify data was inserted
SELECT 'Institusi Count:' as info, COUNT(*) as total FROM institusi;
SELECT 'Jenjang Count:' as info, COUNT(*) as total FROM jenjang;
SELECT 'UPPS Count:' as info, COUNT(*) as total FROM upps;
SELECT 'Prodi Count:' as info, COUNT(*) as total FROM prodi;
SELECT 'Skema Pembayaran Count:' as info, COUNT(*) as total FROM skema_pembayaran;
SELECT 'Bank Count:' as info, COUNT(*) as total FROM bank;
