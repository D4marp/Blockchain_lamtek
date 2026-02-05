-- ====================================================
-- SEED DATA UNTUK MASTER DATA YANG MASIH KOSONG
-- ====================================================

-- ====================================================
-- 1. ASESOR (10 entries)
-- ====================================================
INSERT INTO asesor (nidn, nama_lengkap, gelar_depan, gelar_belakang, jenis_asesor, status, no_hp, email, institusi_asal, bidang_keahlian, is_active, created_at, updated_at) VALUES
('0001111111', 'Prof. Dr. Ahmad Hidayat', 'Prof.', 'Ph.D.', 'ASESOR_AK', 'AKTIF', '08123456789', 'ahmad.hidayat@univ.ac.id', 'Universitas Indonesia', 'Teknik Sipil', true, NOW(), NOW()),
('0002222222', 'Dr. Siti Nur Azizah', 'Dr.', 'M.Si.', 'ASESOR_AL', 'AKTIF', '08234567890', 'siti.azizah@univ.ac.id', 'ITB', 'Teknik Mesin', true, NOW(), NOW()),
('0003333333', 'Prof. Dr. Bambang Sutrisno', 'Prof.', 'Ph.D.', 'ASESOR_AK_AL', 'AKTIF', '08345678901', 'bambang.sutrisno@univ.ac.id', 'Universitas Indonesia', 'Teknik Elektro', true, NOW(), NOW()),
('0004444444', 'Dr. Eka Prasetya', 'Dr.', 'M.Eng.', 'ASESOR_AK', 'AKTIF', '08456789012', 'eka.prasetya@univ.ac.id', 'USU', 'Teknik Kimia', true, NOW(), NOW()),
('0005555555', 'Prof. Dr. Rini Hartanti', 'Prof.', 'Ph.D.', 'ASESOR_AL', 'AKTIF', '08567890123', 'rini.hartanti@univ.ac.id', 'Unair', 'Teknik Industri', true, NOW(), NOW()),
('0006666666', 'Dr. Hendra Wijaya', 'Dr.', 'M.Sc.', 'ASESOR_AK_AL', 'AKTIF', '08678901234', 'hendra.wijaya@univ.ac.id', 'UPI', 'Informatika', true, NOW(), NOW()),
('0007777777', 'Dr. Niluh Suryani', 'Dr.', 'M.Si.', 'ASESOR_AK', 'AKTIF', '08789012345', 'niluh.suryani@univ.ac.id', 'ITB', 'Sistem Informasi', true, NOW(), NOW()),
('0008888888', 'Prof. Dr. Yusuf Rahman', 'Prof.', 'Ph.D.', 'ASESOR_AL', 'AKTIF', '08890123456', 'yusuf.rahman@univ.ac.id', 'USU', 'Manajemen', true, NOW(), NOW()),
('0009999999', 'Dr. Dwi Haryanto', 'Dr.', 'M.Tech.', 'ASESOR_AK_AL', 'AKTIF', '08901234567', 'dwi.haryanto@univ.ac.id', 'Universitas Indonesia', 'Akuntansi', true, NOW(), NOW()),
('0010101010', 'Dr. Lina Setyaningrum', 'Dr.', 'M.Pd.', 'ASESOR_AK', 'AKTIF', '08912345678', 'lina.setyaningrum@univ.ac.id', 'Unair', 'Hukum', true, NOW(), NOW());

-- ====================================================
-- 2. KOMITE EVALUASI (8 entries)
-- ====================================================
INSERT INTO komite_evaluasi (nip, nama_lengkap, gelar_depan, gelar_belakang, jabatan, email, no_hp, is_active, created_at, updated_at) VALUES
('198001011005001', 'Dr. Ir. Teguh Subroto', 'Dr.', 'M.Eng.', 'KETUA', 'teguh.subroto@ristekdikti.go.id', '021-5725900', true, NOW(), NOW()),
('198502021006002', 'Dra. Tri Astuti', 'Dra.', 'M.Si.', 'WAKIL_KETUA', 'tri.astuti@ristekdikti.go.id', '021-5725901', true, NOW(), NOW()),
('197503031987021', 'Dr. Budi Santoso', 'Dr.', 'S.E.', 'SEKRETARIS', 'budi.santoso@ristekdikti.go.id', '021-5725902', true, NOW(), NOW()),
('198603041989031', 'Ir. Hendra Kusuma', 'Ir.', 'M.T.', 'ANGGOTA', 'hendra.kusuma@ristekdikti.go.id', '021-5725903', true, NOW(), NOW()),
('197704051990041', 'Dr. Susi Wirdaningsih', 'Dr.', 'M.Ed.', 'ANGGOTA', 'susi.wirdaningsih@ristekdikti.go.id', '021-5725904', true, NOW(), NOW()),
('198805061991051', 'Prof. Dr. Bambang Setiawan', 'Prof.', 'Ph.D.', 'ANGGOTA', 'bambang.setiawan@ristekdikti.go.id', '021-5725905', true, NOW(), NOW()),
('197906071992061', 'Dr. Rina Purwana', 'Dr.', 'M.Si.', 'ANGGOTA', 'rina.purwana@ristekdikti.go.id', '021-5725906', true, NOW(), NOW()),
('198007081993071', 'Ir. Joko Harsono', 'Ir.', 'M.T.', 'ANGGOTA', 'joko.harsono@ristekdikti.go.id', '021-5725907', true, NOW(), NOW());

-- ====================================================
-- 3. MAJELIS AKREDITASI (8 entries)
-- ====================================================
INSERT INTO majelis_akreditasi (nip, nama_lengkap, gelar_depan, gelar_belakang, jabatan, email, no_hp, is_active, created_at, updated_at) VALUES
('197801011984011', 'Prof. Dr. Kusumadewi', 'Prof.', 'Ph.D.', 'KETUA', 'kusumadewi@ristekdikti.go.id', '021-5726000', true, NOW(), NOW()),
('198502021987021', 'Dr. Sutrisno Hadi', 'Dr.', 'M.Sc.', 'WAKIL_KETUA', 'sutrisno.hadi@ristekdikti.go.id', '021-5726001', true, NOW(), NOW()),
('197603031988031', 'Ir. Adi Wijaya', 'Ir.', 'M.T.', 'SEKRETARIS', 'adi.wijaya@ristekdikti.go.id', '021-5726002', true, NOW(), NOW()),
('198704041989041', 'Dr. Liswanti Sanjaya', 'Dr.', 'S.H.', 'ANGGOTA', 'liswanti.sanjaya@ristekdikti.go.id', '021-5726003', true, NOW(), NOW()),
('197805051990051', 'Prof. Dr. Gunawan Mulia', 'Prof.', 'Ph.D.', 'ANGGOTA', 'gunawan.mulia@ristekdikti.go.id', '021-5726004', true, NOW(), NOW()),
('198906061991061', 'Dr. Slamet Riyadi', 'Dr.', 'M.Ed.', 'ANGGOTA', 'slamet.riyadi@ristekdikti.go.id', '021-5726005', true, NOW(), NOW()),
('197907071992071', 'Ir. Wati Hermanto', 'Ir.', 'M.T.', 'ANGGOTA', 'wati.hermanto@ristekdikti.go.id', '021-5726006', true, NOW(), NOW()),
('198008081993081', 'Dr. Kartini Suhardi', 'Dr.', 'M.Si.', 'ANGGOTA', 'kartini.suhardi@ristekdikti.go.id', '021-5726007', true, NOW(), NOW());

-- ====================================================
-- 4. SEKRETARIAT (6 entries)
-- ====================================================
INSERT INTO sekretariat (nip, nama_lengkap, jabatan, email, no_hp, is_active, created_at, updated_at) VALUES
('197501011985011', 'Drs. Sudirman', 'KEPALA', 'sudirman@ristekdikti.go.id', '021-5727000', true, NOW(), NOW()),
('198602021986021', 'Siti Nurhaliza, S.E.', 'WAKIL_KEPALA', 'siti.nurhaliza@ristekdikti.go.id', '021-5727001', true, NOW(), NOW()),
('197703031987031', 'Eka Putri Wijaya, S.Kom.', 'STAFF', 'eka.putri@ristekdikti.go.id', '021-5727002', true, NOW(), NOW()),
('198804041988041', 'Rasyid Hidayat, S.Adm.', 'STAFF', 'rasyid.hidayat@ristekdikti.go.id', '021-5727003', true, NOW(), NOW()),
('197905051989051', 'Dewi Maryani, S.E.', 'STAFF', 'dewi.maryani@ristekdikti.go.id', '021-5727004', true, NOW(), NOW()),
('198906061990061', 'Hendra Gunawan, S.T.', 'ADMIN', 'hendra.gunawan@ristekdikti.go.id', '021-5727005', true, NOW(), NOW());

-- ====================================================
-- 5. PROVINSI (34 entries) - All Indonesia Provinces
-- ====================================================
INSERT INTO provinsi (kode_provinsi, nama_provinsi, is_active, created_at, updated_at) VALUES
('11', 'Aceh', true, NOW(), NOW()),
('12', 'Sumatera Utara', true, NOW(), NOW()),
('13', 'Sumatera Barat', true, NOW(), NOW()),
('14', 'Riau', true, NOW(), NOW()),
('15', 'Jambi', true, NOW(), NOW()),
('16', 'Sumatera Selatan', true, NOW(), NOW()),
('17', 'Lampung', true, NOW(), NOW()),
('18', 'Bangka Belitung', true, NOW(), NOW()),
('19', 'Kepulauan Riau', true, NOW(), NOW()),
('21', 'Jawa Barat', true, NOW(), NOW()),
('31', 'DKI Jakarta', true, NOW(), NOW()),
('32', 'Jawa Tengah', true, NOW(), NOW()),
('33', 'DI Yogyakarta', true, NOW(), NOW()),
('34', 'Jawa Timur', true, NOW(), NOW()),
('35', 'Banten', true, NOW(), NOW()),
('36', 'Bali', true, NOW(), NOW()),
('51', 'Nusa Tenggara Barat', true, NOW(), NOW()),
('52', 'Nusa Tenggara Timur', true, NOW(), NOW()),
('61', 'Kalimantan Barat', true, NOW(), NOW()),
('62', 'Kalimantan Tengah', true, NOW(), NOW()),
('63', 'Kalimantan Selatan', true, NOW(), NOW()),
('64', 'Kalimantan Timur', true, NOW(), NOW()),
('65', 'Kalimantan Utara', true, NOW(), NOW()),
('71', 'Sulawesi Utara', true, NOW(), NOW()),
('72', 'Sulawesi Tengah', true, NOW(), NOW()),
('73', 'Sulawesi Selatan', true, NOW(), NOW()),
('74', 'Sulawesi Tenggara', true, NOW(), NOW()),
('75', 'Gorontalo', true, NOW(), NOW()),
('76', 'Sulawesi Barat', true, NOW(), NOW()),
('81', 'Maluku', true, NOW(), NOW()),
('82', 'Maluku Utara', true, NOW(), NOW()),
('91', 'Papua Barat', true, NOW(), NOW()),
('94', 'Papua', true, NOW(), NOW()),
('95', 'Papua Tengah', true, NOW(), NOW());

-- ====================================================
-- 6. KLASTER PRODI (12 entries)
-- ====================================================
INSERT INTO klaster_prodi (kode_klaster, nama_klaster, deskripsi, is_active, created_at, updated_at) VALUES
('KLPR001', 'Teknik Sipil', 'Program studi bidang teknik sipil dan infrastruktur', true, NOW(), NOW()),
('KLPR002', 'Teknik Mesin', 'Program studi bidang teknik mesin dan manufaktur', true, NOW(), NOW()),
('KLPR003', 'Teknik Elektro', 'Program studi bidang teknik elektro dan energi', true, NOW(), NOW()),
('KLPR004', 'Teknik Kimia', 'Program studi bidang teknik kimia dan material', true, NOW(), NOW()),
('KLPR005', 'Teknik Industri', 'Program studi bidang teknik industri dan manajemen', true, NOW(), NOW()),
('KLPR006', 'Informatika', 'Program studi bidang ilmu komputer dan informatika', true, NOW(), NOW()),
('KLPR007', 'Sistem Informasi', 'Program studi bidang sistem informasi', true, NOW(), NOW()),
('KLPR008', 'Manajemen', 'Program studi bidang manajemen dan bisnis', true, NOW(), NOW()),
('KLPR009', 'Akuntansi', 'Program studi bidang akuntansi dan keuangan', true, NOW(), NOW()),
('KLPR010', 'Hukum', 'Program studi bidang ilmu hukum', true, NOW(), NOW()),
('KLPR011', 'Pendidikan', 'Program studi bidang keguruan dan ilmu pendidikan', true, NOW(), NOW()),
('KLPR012', 'Kesehatan', 'Program studi bidang kesehatan dan kedokteran', true, NOW(), NOW());

-- ====================================================
-- 7. KLASTER PROFESI (6 entries)
-- ====================================================
INSERT INTO klaster_profesi (kode_klaster, nama_klaster, deskripsi, is_active, created_at, updated_at) VALUES
('KLPF001', 'Insinyur Sipil', 'Profesi Insinyur Sipil - Struktur dan Konstruksi', true, NOW(), NOW()),
('KLPF002', 'Insinyur Mesin', 'Profesi Insinyur Mesin - Perancangan dan Pabrikasi', true, NOW(), NOW()),
('KLPF003', 'Insinyur Elektro', 'Profesi Insinyur Elektro - Tenaga dan Industri', true, NOW(), NOW()),
('KLPF004', 'Insinyur Kimia', 'Profesi Insinyur Kimia - Proses dan Produksi', true, NOW(), NOW()),
('KLPF005', 'Insinyur Industri', 'Profesi Insinyur Industri - Sistem dan Produksi', true, NOW(), NOW()),
('KLPF006', 'Insinyur Komputer', 'Profesi Insinyur Komputer - Perangkat Keras dan Lunak', true, NOW(), NOW());

-- ====================================================
-- 8. STATUS SK (6 entries)
-- ====================================================
INSERT INTO status_sk (kode_status, nama_status, deskripsi, warna, urutan, is_active, created_at, updated_at) VALUES
('DRAFT', 'Draft', 'Status SK masih dalam bentuk draft', '#CCCCCC', 1, true, NOW(), NOW()),
('PROSES_VERIFIKASI', 'Proses Verifikasi', 'Status SK sedang dalam proses verifikasi', '#FFA500', 2, true, NOW(), NOW()),
('VERIFIED', 'Terverifikasi', 'Status SK telah terverifikasi', '#4169E1', 3, true, NOW(), NOW()),
('DITOLAK', 'Ditolak', 'Status SK ditolak dalam verifikasi', '#FF0000', 4, true, NOW(), NOW()),
('DITERBITKAN', 'Diterbitkan', 'Status SK telah diterbitkan resmi', '#228B22', 5, true, NOW(), NOW()),
('KADALUARSA', 'Kadaluarsa', 'Status SK tidak berlaku lagi', '#696969', 6, true, NOW(), NOW());

-- ====================================================
-- 9. KRITERIA PENILAIAN (15 entries)
-- ====================================================
INSERT INTO kriteria_penilaian (kode_kriteria, nama_kriteria, deskripsi, urutan, bobot, is_active, created_at, updated_at) VALUES
('KRIT001', 'Standar Pendidikan', 'Evaluasi standar pendidikan dan kurikulum', 1, 10.00, true, NOW(), NOW()),
('KRIT002', 'Standar Tenaga Akademik', 'Evaluasi kualifikasi dan kompetensi tenaga akademik', 2, 15.00, true, NOW(), NOW()),
('KRIT003', 'Standar Sarana dan Prasarana', 'Evaluasi kelengkapan sarana dan prasarana', 3, 10.00, true, NOW(), NOW()),
('KRIT004', 'Standar Penyelenggaraan Pendidikan', 'Evaluasi proses penyelenggaraan pendidikan', 4, 12.00, true, NOW(), NOW()),
('KRIT005', 'Standar Pembiayaan dan Pengelolaan Keuangan', 'Evaluasi pengelolaan keuangan dan pembiayaan', 5, 8.00, true, NOW(), NOW()),
('KRIT006', 'Standar Penilaian Pendidikan', 'Evaluasi sistem penilaian dan penjaminan mutu', 6, 12.00, true, NOW(), NOW()),
('KRIT007', 'Standar Penelitian', 'Evaluasi kegiatan penelitian dan publikasi', 7, 10.00, true, NOW(), NOW()),
('KRIT008', 'Standar Pengabdian kepada Masyarakat', 'Evaluasi kegiatan pengabdian masyarakat', 8, 8.00, true, NOW(), NOW()),
('KRIT009', 'Standar Kemahasiswaan dan Lulusan', 'Evaluasi pembimbingan dan pencapaian mahasiswa', 9, 10.00, true, NOW(), NOW()),
('KRIT010', 'Kerjasama dengan Institusi Lain', 'Evaluasi kerjasama akademik dan industri', 10, 5.00, true, NOW(), NOW()),
('KRIT011', 'Kompetensi Lulusan', 'Evaluasi kompetensi dan relevansi lulusan', 11, 12.00, true, NOW(), NOW()),
('KRIT012', 'Etika dan Profesionalisme', 'Evaluasi etika dan nilai profesionalisme', 12, 5.00, true, NOW(), NOW()),
('KRIT013', 'Inovasi dan Keberlanjutan', 'Evaluasi inovasi dan keberlanjutan program', 13, 8.00, true, NOW(), NOW()),
('KRIT014', 'Responsif terhadap Kebutuhan Pasar', 'Evaluasi kesesuaian dengan kebutuhan industri', 14, 7.00, true, NOW(), NOW()),
('KRIT015', 'Manajemen dan Kepemimpinan', 'Evaluasi struktur manajemen dan kepemimpinan', 15, 7.00, true, NOW(), NOW());

-- ====================================================
-- Verify Data Insertion
-- ====================================================
SELECT 'Asesor' as table_name, COUNT(*) as jumlah_data FROM asesor
UNION ALL
SELECT 'Komite Evaluasi', COUNT(*) FROM komite_evaluasi
UNION ALL
SELECT 'Majelis Akreditasi', COUNT(*) FROM majelis_akreditasi
UNION ALL
SELECT 'Sekretariat', COUNT(*) FROM sekretariat
UNION ALL
SELECT 'Provinsi', COUNT(*) FROM provinsi
UNION ALL
SELECT 'Klaster Prodi', COUNT(*) FROM klaster_prodi
UNION ALL
SELECT 'Klaster Profesi', COUNT(*) FROM klaster_profesi
UNION ALL
SELECT 'Status SK', COUNT(*) FROM status_sk
UNION ALL
SELECT 'Kriteria Penilaian', COUNT(*) FROM kriteria_penilaian;
