-- Create Master Data Tables based on TypeORM Entity Definitions

-- Drop tables if they exist (reverse order due to foreign keys)
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `skema_pembayaran`;
DROP TABLE IF EXISTS `bank`;
DROP TABLE IF EXISTS `prodi`;
DROP TABLE IF EXISTS `upps`;
DROP TABLE IF EXISTS `jenjang`;
DROP TABLE IF EXISTS `institusi`;
SET FOREIGN_KEY_CHECKS=1;

-- 1. Create Institusi Table
CREATE TABLE `institusi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_institusi` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_institusi` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_singkat` varchar(50) COLLATE utf8mb4_unicode_ci,
  `jenis_pt` enum('PTN','PTS','PTN_BH','POLITEKNIK') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PTS',
  `provinsi_id` bigint unsigned,
  `alamat` varchar(255) COLLATE utf8mb4_unicode_ci,
  `kota` varchar(100) COLLATE utf8mb4_unicode_ci,
  `kode_pos` varchar(10) COLLATE utf8mb4_unicode_ci,
  `telepon` varchar(20) COLLATE utf8mb4_unicode_ci,
  `fax` varchar(20) COLLATE utf8mb4_unicode_ci,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci,
  `nama_rektor` varchar(255) COLLATE utf8mb4_unicode_ci,
  `sk_pendirian` varchar(255) COLLATE utf8mb4_unicode_ci,
  `tanggal_sk_pendirian` date,
  `status` enum('AKTIF','TIDAK_AKTIF','MERGER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AKTIF',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_institusi` (`kode_institusi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Create Jenjang Table
CREATE TABLE `jenjang` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_jenjang` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_jenjang` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  `urutan` int NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_jenjang` (`kode_jenjang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Create UPPS Table
CREATE TABLE `upps` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_upps` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_upps` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `nama_pimpinan` varchar(255) COLLATE utf8mb4_unicode_ci,
  `jabatan_pimpinan` varchar(100) COLLATE utf8mb4_unicode_ci,
  `alamat` varchar(255) COLLATE utf8mb4_unicode_ci,
  `telepon` varchar(20) COLLATE utf8mb4_unicode_ci,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_upps` (`kode_upps`),
  KEY `idx_institusi_id` (`institusi_id`),
  CONSTRAINT `fk_upps_institusi` FOREIGN KEY (`institusi_id`) REFERENCES `institusi` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Create Prodi Table
CREATE TABLE `prodi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_prodi` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_prodi` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `klaster_ilmu_id` bigint unsigned,
  `klaster_prodi_id` bigint unsigned,
  `sk_pendirian` varchar(255) COLLATE utf8mb4_unicode_ci,
  `tanggal_sk_pendirian` date,
  `sk_operasional` varchar(255) COLLATE utf8mb4_unicode_ci,
  `tanggal_sk_operasional` date,
  `alamat` varchar(255) COLLATE utf8mb4_unicode_ci,
  `telepon` varchar(20) COLLATE utf8mb4_unicode_ci,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci,
  `nama_kaprodi` varchar(255) COLLATE utf8mb4_unicode_ci,
  `nidn_kaprodi` varchar(50) COLLATE utf8mb4_unicode_ci,
  `jumlah_mahasiswa` int NOT NULL DEFAULT 0,
  `jumlah_dosen` int NOT NULL DEFAULT 0,
  `status` enum('AKTIF','TIDAK_AKTIF','PEMBINAAN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AKTIF',
  `peringkat_akreditasi_terakhir` varchar(50) COLLATE utf8mb4_unicode_ci,
  `tanggal_akreditasi_berakhir` date,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_prodi` (`kode_prodi`),
  KEY `idx_institusi_id` (`institusi_id`),
  KEY `idx_jenjang_id` (`jenjang_id`),
  CONSTRAINT `fk_prodi_institusi` FOREIGN KEY (`institusi_id`) REFERENCES `institusi` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_prodi_jenjang` FOREIGN KEY (`jenjang_id`) REFERENCES `jenjang` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Create Skema Pembayaran Table
CREATE TABLE `skema_pembayaran` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_skema` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_skema` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipe` enum('REGULER','PJJ','PRODI_BARU') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'REGULER',
  `jenjang_id` bigint unsigned,
  `biaya_pendaftaran` decimal(15,2) NOT NULL DEFAULT 0.00,
  `biaya_asesmen_kecukupan` decimal(15,2) NOT NULL DEFAULT 0.00,
  `biaya_asesmen_lapangan` decimal(15,2) NOT NULL DEFAULT 0.00,
  `biaya_sk` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_biaya` decimal(15,2) NOT NULL DEFAULT 0.00,
  `keterangan` text COLLATE utf8mb4_unicode_ci,
  `berlaku_mulai` date,
  `berlaku_sampai` date,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_skema` (`kode_skema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Create Bank Table
CREATE TABLE `bank` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_bank` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_bank` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_rekening` varchar(255) COLLATE utf8mb4_unicode_ci,
  `nomor_rekening` varchar(50) COLLATE utf8mb4_unicode_ci,
  `cabang` varchar(100) COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kode_bank` (`kode_bank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
