-- Seed Master Data untuk Registrasi Akreditasi
-- Struktur sesuai dengan TypeORM entities

-- 1. Seed Institusi
INSERT INTO institusi (kode_institusi, nama_institusi, nama_singkat, jenis_pt, provinsi_id, alamat, kota, kode_pos, telepon, fax, email, website, nama_rektor, sk_pendirian, tanggal_sk_pendirian, status, is_active, created_at, updated_at) VALUES
('UNIV001', 'Universitas Indonesia', 'UI', 'PTN', 1, 'Jl. Margonda Raya', 'Depok', '16424', '021-7270000', '021-7270001', 'rektorat@ui.ac.id', 'www.ui.ac.id', 'Prof. Dr. Muhammad Anis', 'KEPUTUSAN/001/1950', '1950-09-02', 'AKTIF', 1, NOW(), NOW()),
('UNIV002', 'Institut Teknologi Bandung', 'ITB', 'PTN', 2, 'Jl. Ganesha 10', 'Bandung', '40132', '0274-513220', '0274-513299', 'rektorat@itb.ac.id', 'www.itb.ac.id', 'Prof. Ir. Wawan Hermawan', 'KEPUTUSAN/002/1945', '1945-03-03', 'AKTIF', 1, NOW(), NOW()),
('UNIV003', 'Universitas Sumatera Utara', 'USU', 'PTN', 3, 'Jl. Universitas No. 19', 'Medan', '20155', '061-8213737', '061-8213736', 'rektorat@usu.ac.id', 'www.usu.ac.id', 'Prof. Dr. Runtung Sitepu', 'KEPUTUSAN/003/1952', '1952-11-14', 'AKTIF', 1, NOW(), NOW()),
('UNIV004', 'Universitas Pendidikan Indonesia', 'UPI', 'PTN', 2, 'Jl. Dr. Setiabudi 229', 'Bandung', '40154', '0274-200066', '0274-200067', 'rektorat@upi.edu', 'www.upi.edu', 'Prof. Dr. Kokom Komalasari', 'KEPUTUSAN/004/1954', '1954-06-20', 'AKTIF', 1, NOW(), NOW()),
('UNIV005', 'Universitas Airlangga', 'UNAIR', 'PTN', 4, 'Kampus A Jl. Mulyorejo', 'Surabaya', '60115', '031-5033000', '031-5034444', 'rektorat@unair.ac.id', 'www.unair.ac.id', 'Prof. Dr. Bambang Irawan', 'KEPUTUSAN/005/1954', '1954-09-10', 'AKTIF', 1, NOW(), NOW());

-- 2. Seed Jenjang
INSERT INTO jenjang (kode_jenjang, nama_jenjang, deskripsi, urutan, is_active, created_at, updated_at) VALUES
('D3', 'Diploma Tiga', 'Program Diploma 3 Tahun', 1, 1, NOW(), NOW()),
('D4', 'Diploma Empat', 'Program Diploma 4 Tahun', 2, 1, NOW(), NOW()),
('S1', 'Sarjana', 'Program Sarjana / Strata 1', 3, 1, NOW(), NOW()),
('S2', 'Magister', 'Program Magister / Strata 2', 4, 1, NOW(), NOW()),
('S3', 'Doktor', 'Program Doktor / Strata 3', 5, 1, NOW(), NOW()),
('PROFESI', 'Program Profesi', 'Program Profesi Setelah Sarjana', 6, 1, NOW(), NOW());

-- 3. Seed UPPS (Unit Penyelenggara Program Studi)
INSERT INTO upps (kode_upps, nama_upps, institusi_id, nama_pimpinan, jabatan_pimpinan, alamat, telepon, email, website, is_active, created_at, updated_at) VALUES
('UPPS001', 'Fakultas Teknik', 1, 'Dr. Budi Santoso', 'Dekan', 'Gedung A Kampus UI', '021-7270100', 'ft@ui.ac.id', 'ft.ui.ac.id', 1, NOW(), NOW()),
('UPPS002', 'Fakultas MIPA', 2, 'Prof. Ir. Ahmad Syukri', 'Dekan', 'Gedung B Kampus ITB', '0274-513300', 'fmipa@itb.ac.id', 'fmipa.itb.ac.id', 1, NOW(), NOW()),
('UPPS003', 'Fakultas Hukum', 1, 'Dr. Siti Nurhaliza', 'Dekan', 'Gedung C Kampus UI', '021-7270200', 'fh@ui.ac.id', 'fh.ui.ac.id', 1, NOW(), NOW()),
('UPPS004', 'Fakultas Ekonomi Bisnis', 3, 'Dr. Rudi Hartono', 'Dekan', 'Gedung D Kampus USU', '061-8213800', 'feb@usu.ac.id', 'feb.usu.ac.id', 1, NOW(), NOW()),
('UPPS005', 'Fakultas Pendidikan', 4, 'Prof. Dedi Kusniadi', 'Dekan', 'Gedung E Kampus UPI', '0274-200100', 'fp@upi.edu', 'fp.upi.edu', 1, NOW(), NOW()),
('UPPS006', 'Fakultas Ilmu Sosial', 5, 'Dr. Eka Suryanto', 'Dekan', 'Gedung F Kampus Unair', '031-5033100', 'fis@unair.ac.id', 'fis.unair.ac.id', 1, NOW(), NOW()),
('UPPS007', 'Sekolah Pascasarjana', 1, 'Prof. Dr. Triyono', 'Direktur', 'Gedung G Kampus UI', '021-7270300', 'spg@ui.ac.id', 'spg.ui.ac.id', 1, NOW(), NOW()),
('UPPS008', 'Politeknik Negeri', 2, 'Dr. Bambang Setiawan', 'Direktur', 'Gedung H Kampus ITB', '0274-513400', 'pn@itb.ac.id', 'pn.itb.ac.id', 1, NOW(), NOW());

-- 4. Seed Prodi (Program Studi)
INSERT INTO prodi (kode_prodi, nama_prodi, institusi_id, jenjang_id, sk_pendirian, tanggal_sk_pendirian, sk_operasional, tanggal_sk_operasional, alamat, telepon, email, website, nama_kaprodi, nidn_kaprodi, jumlah_mahasiswa, jumlah_dosen, status, peringkat_akreditasi_terakhir, tanggal_akreditasi_berakhir, is_active, created_at, updated_at) VALUES
('PRODI001', 'Teknik Informatika', 1, 3, 'SK-001/2015', '2015-03-01', 'SK-OP-001/2015', '2015-04-01', 'Jl. Margonda Raya', '021-7270400', 'ti@ui.ac.id', 'ti.ui.ac.id', 'Dr. Andi Wijaya', '0001234567', 500, 45, 'AKTIF', 'A', '2025-12-31', 1, NOW(), NOW()),
('PRODI002', 'Teknik Elektro', 1, 3, 'SK-002/2015', '2015-03-01', 'SK-OP-002/2015', '2015-04-01', 'Jl. Margonda Raya', '021-7270401', 'te@ui.ac.id', 'te.ui.ac.id', 'Prof. Ir. Bambang', '0001234568', 480, 42, 'AKTIF', 'B', '2026-06-30', 1, NOW(), NOW()),
('PRODI003', 'Teknik Sipil', 1, 3, 'SK-003/2015', '2015-03-01', 'SK-OP-003/2015', '2015-04-01', 'Jl. Margonda Raya', '021-7270402', 'ts@ui.ac.id', 'ts.ui.ac.id', 'Dr. Sujito', '0001234569', 450, 40, 'AKTIF', 'A', '2026-03-31', 1, NOW(), NOW()),
('PRODI004', 'Fisika', 2, 3, 'SK-004/2014', '2014-05-01', 'SK-OP-004/2014', '2014-06-01', 'Jl. Ganesha 10', '0274-513500', 'fis@itb.ac.id', 'fis.itb.ac.id', 'Dr. Rendra', '0001234570', 380, 35, 'AKTIF', 'B', '2027-05-31', 1, NOW(), NOW()),
('PRODI005', 'Kimia', 2, 3, 'SK-005/2014', '2014-05-01', 'SK-OP-005/2014', '2014-06-01', 'Jl. Ganesha 10', '0274-513501', 'kim@itb.ac.id', 'kim.itb.ac.id', 'Prof. Dr. Bambang', '0001234571', 320, 32, 'AKTIF', 'A', '2025-08-31', 1, NOW(), NOW()),
('PRODI006', 'Hukum Pidana', 1, 3, 'SK-006/2013', '2013-06-01', 'SK-OP-006/2013', '2013-07-01', 'Jl. Margonda Raya', '021-7270403', 'hp@ui.ac.id', 'hp.ui.ac.id', 'Dr. Eka Prasetya', '0001234572', 280, 28, 'AKTIF', 'A', '2024-12-31', 1, NOW(), NOW()),
('PRODI007', 'Manajemen', 3, 3, 'SK-007/2016', '2016-02-01', 'SK-OP-007/2016', '2016-03-01', 'Jl. Universitas No. 19', '061-8213900', 'mgmt@usu.ac.id', 'mgmt.usu.ac.id', 'Dr. Sudarno', '0001234573', 550, 48, 'AKTIF', 'B', '2026-02-28', 1, NOW(), NOW()),
('PRODI008', 'Akuntansi', 3, 3, 'SK-008/2016', '2016-02-01', 'SK-OP-008/2016', '2016-03-01', 'Jl. Universitas No. 19', '061-8213901', 'akut@usu.ac.id', 'akut.usu.ac.id', 'Dr. Taufiq', '0001234574', 520, 46, 'AKTIF', 'A', '2025-11-30', 1, NOW(), NOW()),
('PRODI009', 'Pendidikan Matematika', 4, 3, 'SK-009/2012', '2012-01-15', 'SK-OP-009/2012', '2012-02-15', 'Jl. Dr. Setiabudi 229', '0274-200200', 'pm@upi.edu', 'pm.upi.edu', 'Dr. Heris Hendriana', '0001234575', 400, 36, 'AKTIF', 'B', '2027-01-14', 1, NOW(), NOW()),
('PRODI010', 'Pendidikan Bahasa Indonesia', 4, 3, 'SK-010/2012', '2012-01-15', 'SK-OP-010/2012', '2012-02-15', 'Jl. Dr. Setiabudi 229', '0274-200201', 'pbi@upi.edu', 'pbi.upi.edu', 'Dr. Dadang Sunendar', '0001234576', 350, 32, 'AKTIF', 'A', '2026-10-14', 1, NOW(), NOW()),
('PRODI011', 'Magister Teknik Informatika', 1, 4, 'SK-011/2017', '2017-08-01', 'SK-OP-011/2017', '2017-09-01', 'Jl. Margonda Raya', '021-7270404', 'mti@ui.ac.id', 'mti.ui.ac.id', 'Dr. Arif Budiarto', '0001234577', 180, 25, 'AKTIF', 'A', '2026-07-31', 1, NOW(), NOW()),
('PRODI012', 'Magister Fisika', 2, 4, 'SK-012/2018', '2018-09-01', 'SK-OP-012/2018', '2018-10-01', 'Jl. Ganesha 10', '0274-513502', 'mfis@itb.ac.id', 'mfis.itb.ac.id', 'Prof. Dr. Kusnanto', '0001234578', 120, 18, 'AKTIF', 'B', '2028-08-31', 1, NOW(), NOW()),
('PRODI013', 'Magister Hukum', 1, 4, 'SK-013/2018', '2018-03-01', 'SK-OP-013/2018', '2018-04-01', 'Jl. Margonda Raya', '021-7270405', 'mh@ui.ac.id', 'mh.ui.ac.id', 'Prof. Dr. Supriyanto', '0001234579', 150, 20, 'AKTIF', 'A', '2027-02-28', 1, NOW(), NOW()),
('PRODI014', 'Magister Ekonomi', 3, 4, 'SK-014/2019', '2019-05-01', 'SK-OP-014/2019', '2019-06-01', 'Jl. Universitas No. 19', '061-8213902', 'mekon@usu.ac.id', 'mekon.usu.ac.id', 'Dr. Agustina Pasaribu', '0001234580', 140, 19, 'AKTIF', 'B', '2028-04-30', 1, NOW(), NOW()),
('PRODI015', 'Doktor Teknik', 1, 5, 'SK-015/2019', '2019-07-01', 'SK-OP-015/2019', '2019-08-01', 'Jl. Margonda Raya', '021-7270406', 'dtek@ui.ac.id', 'dtek.ui.ac.id', 'Prof. Ir. Djoko Sartono', '0001234581', 80, 15, 'AKTIF', 'A', '2028-06-30', 1, NOW(), NOW()),
('PRODI016', 'Doktor Sains', 2, 5, 'SK-016/2019', '2019-08-01', 'SK-OP-016/2019', '2019-09-01', 'Jl. Ganesha 10', '0274-513503', 'dsains@itb.ac.id', 'dsains.itb.ac.id', 'Prof. Dr. Suryadi', '0001234582', 60, 12, 'AKTIF', 'A', '2028-07-31', 1, NOW(), NOW()),
('PRODI017', 'Doktor Ilmu Hukum', 1, 5, 'SK-017/2020', '2020-03-01', 'SK-OP-017/2020', '2020-04-01', 'Jl. Margonda Raya', '021-7270407', 'dih@ui.ac.id', 'dih.ui.ac.id', 'Prof. Dr. Edi Suharto', '0001234583', 70, 13, 'AKTIF', 'B', '2029-02-28', 1, NOW(), NOW()),
('PRODI018', 'Profesi Arsitek', 1, 6, 'SK-018/2020', '2020-06-01', 'SK-OP-018/2020', '2020-07-01', 'Jl. Margonda Raya', '021-7270408', 'pa@ui.ac.id', 'pa.ui.ac.id', 'Dr. Bambang Setiawan', '0001234584', 200, 22, 'AKTIF', 'A', '2026-05-31', 1, NOW(), NOW());

-- 5. Seed Skema Pembayaran
INSERT INTO skema_pembayaran (kode_skema, nama_skema, tipe, jenjang_id, biaya_pendaftaran, biaya_asesmen_kecukupan, biaya_asesmen_lapangan, biaya_sk, total_biaya, keterangan, berlaku_mulai, berlaku_sampai, is_active, created_at, updated_at) VALUES
('SKM001', 'Reguler D3/D4', 'REGULER', 1, 500000.00, 5000000.00, 7500000.00, 2500000.00, 15500000.00, 'Skema pembayaran reguler untuk Diploma 3 dan Diploma 4', '2024-01-01', '2024-12-31', 1, NOW(), NOW()),
('SKM002', 'Reguler S1', 'REGULER', 3, 500000.00, 6000000.00, 9000000.00, 3000000.00, 18500000.00, 'Skema pembayaran reguler untuk Sarjana', '2024-01-01', '2024-12-31', 1, NOW(), NOW()),
('SKM003', 'Reguler S2/S3', 'REGULER', 4, 750000.00, 7500000.00, 11000000.00, 3500000.00, 22750000.00, 'Skema pembayaran reguler untuk Magister dan Doktor', '2024-01-01', '2024-12-31', 1, NOW(), NOW()),
('SKM004', 'PJJ/Online D3/D4', 'PJJ', 1, 400000.00, 4000000.00, 6000000.00, 2000000.00, 12400000.00, 'Skema pembayaran untuk Program Jarak Jauh Diploma', '2024-01-01', '2024-12-31', 1, NOW(), NOW()),
('SKM005', 'Prodi Baru S1', 'PRODI_BARU', 3, 600000.00, 7000000.00, 10500000.00, 3500000.00, 21600000.00, 'Skema pembayaran untuk Prodi Baru Sarjana', '2024-01-01', '2024-12-31', 1, NOW(), NOW());

-- 6. Seed Bank
INSERT INTO bank (kode_bank, nama_bank, nama_rekening, nomor_rekening, cabang, is_active, created_at, updated_at) VALUES
('BNI', 'Bank Negara Indonesia', 'BLU Kementerian Pendidikan', '0115555111', 'Jakarta Pusat', 1, NOW(), NOW()),
('BCA', 'Bank Central Asia', 'Rekening Khusus Akreditasi', '1234567890', 'Jakarta Selatan', 1, NOW(), NOW()),
('MANDIRI', 'Bank Mandiri', 'BLU Kantor Pusat', '1400011111111', 'Jakarta Pusat', 1, NOW(), NOW()),
('BRI', 'Bank Rakyat Indonesia', 'Rekening Akreditasi Pendidikan', '0063666666', 'Jakarta Pusat', 1, NOW(), NOW());
