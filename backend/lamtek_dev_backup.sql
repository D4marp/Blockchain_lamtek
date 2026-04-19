-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: lamtek_dev
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `akreditasi`
--

DROP TABLE IF EXISTS `akreditasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `akreditasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_akreditasi` varchar(50) NOT NULL,
  `tenant_id` bigint unsigned NOT NULL,
  `upps_id` bigint unsigned NOT NULL,
  `prodi_id` bigint unsigned NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned DEFAULT NULL,
  `tahun` year NOT NULL,
  `tipe` enum('REGULER','PJJ','PRODI_BARU_PTNBH','PRODI_BARU_NON_PTNBH') NOT NULL DEFAULT 'REGULER',
  `status` enum('REGISTRASI','VERIFIKASI_DOKUMEN','PEMBAYARAN','PENAWARAN_ASESOR','ASESMEN_KECUKUPAN','PENGESAHAN_AK','ASESMEN_LAPANGAN','TANGGAPAN_AL','PENGESAHAN_AL','PENETAPAN_PERINGKAT','SINKRONISASI_BANPT','SELESAI') NOT NULL DEFAULT 'REGISTRASI',
  `progress` tinyint NOT NULL DEFAULT '0',
  `info_akreditasi` text,
  `reg_akreditasi_selesai` tinyint NOT NULL DEFAULT '0',
  `wkt_reg_akred_selesai` datetime DEFAULT NULL,
  `penentuan_asesor_selesai` tinyint NOT NULL DEFAULT '0',
  `wkt_penentuan_asesor_selesai` datetime DEFAULT NULL,
  `ak_selesai` tinyint NOT NULL DEFAULT '0',
  `wkt_ak_selesai` datetime DEFAULT NULL,
  `al_selesai` tinyint NOT NULL DEFAULT '0',
  `wkt_al_selesai` datetime DEFAULT NULL,
  `terakreditasi` tinyint NOT NULL DEFAULT '0',
  `peringkat_akred` enum('BELUM_TERAKREDITASI','BAIK','BAIK_SEKALI','UNGGUL') DEFAULT NULL,
  `nilai_akreditasi` int DEFAULT NULL,
  `wkt_terakreditasi` datetime DEFAULT NULL,
  `akreditasi_berlaku_mulai` date DEFAULT NULL,
  `akreditasi_berakhir_pada` date DEFAULT NULL,
  `nomor_sk` varchar(100) DEFAULT NULL,
  `tgl_sk` date DEFAULT NULL,
  `sk_akreditasi` varchar(255) DEFAULT NULL,
  `nomor_sertifikat` varchar(100) DEFAULT NULL,
  `sertifikat` varchar(255) DEFAULT NULL,
  `ipfs_hash_dokumen` varchar(100) DEFAULT NULL,
  `ipfs_hash_sk` varchar(100) DEFAULT NULL,
  `ipfs_hash_sertifikat` varchar(100) DEFAULT NULL,
  `blockchain_tx_hash` varchar(100) DEFAULT NULL,
  `blockchain_block_number` bigint DEFAULT NULL,
  `is_on_blockchain` tinyint NOT NULL DEFAULT '0',
  `uuid_sk_akreditasi` varchar(50) DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_3accc9c982c8e77afd0ed06cf5` (`kode_akreditasi`),
  KEY `IDX_d7ed9c6197a960196ba2edb1d0` (`tenant_id`),
  KEY `IDX_b094f973fc36699e060f1e0845` (`prodi_id`),
  KEY `IDX_266fa6fb5b98dfbb835df2645b` (`institusi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `akreditasi`
--

LOCK TABLES `akreditasi` WRITE;
/*!40000 ALTER TABLE `akreditasi` DISABLE KEYS */;
/*!40000 ALTER TABLE `akreditasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asesmen_kecukupan`
--

DROP TABLE IF EXISTS `asesmen_kecukupan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asesmen_kecukupan` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `kode_akreditasi` varchar(50) NOT NULL,
  `kea_id` bigint unsigned DEFAULT NULL,
  `validator_id` bigint unsigned DEFAULT NULL,
  `tgt_wkt_ak` date DEFAULT NULL,
  `lak_konsisten` tinyint NOT NULL DEFAULT '0',
  `deskripsi_lap_ak` text,
  `hasil_ditetapkan_kea` tinyint NOT NULL DEFAULT '0',
  `note_penetapan_hasil_ak_kea` text,
  `skor_asesmen_konsisten` tinyint NOT NULL DEFAULT '0',
  `skor_per_butir_konsisten` tinyint NOT NULL DEFAULT '0',
  `terkonsolidasi` tinyint NOT NULL DEFAULT '0',
  `skor_akhir` decimal(10,2) DEFAULT NULL,
  `ipfs_hash_laporan_ak` varchar(100) DEFAULT NULL,
  `blockchain_tx_hash` varchar(100) DEFAULT NULL,
  `is_on_blockchain` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_5efea279255b77ac2636eb6572` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asesmen_kecukupan`
--

LOCK TABLES `asesmen_kecukupan` WRITE;
/*!40000 ALTER TABLE `asesmen_kecukupan` DISABLE KEYS */;
/*!40000 ALTER TABLE `asesmen_kecukupan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asesmen_lapangan`
--

DROP TABLE IF EXISTS `asesmen_lapangan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asesmen_lapangan` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `kode_akreditasi` varchar(50) NOT NULL,
  `kea_id` bigint unsigned DEFAULT NULL,
  `tgl_visitasi_awal` date DEFAULT NULL,
  `tgl_visitasi_akhir` date DEFAULT NULL,
  `jadwal_disetujui` tinyint NOT NULL DEFAULT '0',
  `tgt_wkt_al` date DEFAULT NULL,
  `lal_submitted` tinyint NOT NULL DEFAULT '0',
  `hasil_ditetapkan_kea` tinyint NOT NULL DEFAULT '0',
  `note_penetapan_hasil_al_kea` text,
  `no_surat_tugas_al` varchar(100) DEFAULT NULL,
  `rekomendasi_peringkat_kea` varchar(50) DEFAULT NULL,
  `catatan_asesor` text,
  `catatan_lain` text,
  `tanggapan_al` tinyint NOT NULL DEFAULT '0',
  `upps_menanggapi_al` tinyint NOT NULL DEFAULT '0',
  `asesor_menanggapi_al` tinyint NOT NULL DEFAULT '0',
  `deadline_tanggapan_al` date DEFAULT NULL,
  `umpan_balik_asesor_diisi` tinyint NOT NULL DEFAULT '0',
  `ipfs_hash_surat_tugas` varchar(100) DEFAULT NULL,
  `ipfs_hash_berita_acara` varchar(100) DEFAULT NULL,
  `ipfs_hash_umpan_balik` varchar(100) DEFAULT NULL,
  `ipfs_hash_laporan_al` varchar(100) DEFAULT NULL,
  `ipfs_hash_tanggapan_al` varchar(100) DEFAULT NULL,
  `blockchain_tx_hash` varchar(100) DEFAULT NULL,
  `is_on_blockchain` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_f9b15aa1149e18f9dc16af5e60` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asesmen_lapangan`
--

LOCK TABLES `asesmen_lapangan` WRITE;
/*!40000 ALTER TABLE `asesmen_lapangan` DISABLE KEYS */;
/*!40000 ALTER TABLE `asesmen_lapangan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asesor`
--

DROP TABLE IF EXISTS `asesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asesor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nidn` varchar(50) NOT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `gelar_depan` varchar(50) DEFAULT NULL,
  `gelar_belakang` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `institusi_asal` varchar(255) DEFAULT NULL,
  `fakultas_asal` varchar(255) DEFAULT NULL,
  `prodi_asal` varchar(255) DEFAULT NULL,
  `jabatan_fungsional` varchar(100) DEFAULT NULL,
  `pendidikan_terakhir` varchar(50) DEFAULT NULL,
  `bidang_keahlian` varchar(255) DEFAULT NULL,
  `klaster_ilmu_id` bigint unsigned DEFAULT NULL,
  `klaster_profesi_id` bigint unsigned DEFAULT NULL,
  `no_sertifikat` varchar(100) DEFAULT NULL,
  `tanggal_sertifikat` date DEFAULT NULL,
  `masa_berlaku_sertifikat` date DEFAULT NULL,
  `jenis_asesor` enum('ASESOR_AK','ASESOR_AL','ASESOR_AK_AL') NOT NULL DEFAULT 'ASESOR_AK_AL',
  `status` enum('AKTIF','TIDAK_AKTIF','PENSIUN') NOT NULL DEFAULT 'AKTIF',
  `alamat` text,
  `foto_url` varchar(255) DEFAULT NULL,
  `cv_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_895a2ed68ef572216f3de76851` (`email`),
  UNIQUE KEY `IDX_25df1abbb8a0ce6b6bc9657a06` (`nidn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asesor`
--

LOCK TABLES `asesor` WRITE;
/*!40000 ALTER TABLE `asesor` DISABLE KEYS */;
/*!40000 ALTER TABLE `asesor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank`
--

DROP TABLE IF EXISTS `bank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_bank` varchar(20) NOT NULL,
  `nama_bank` varchar(100) NOT NULL,
  `nama_rekening` varchar(255) DEFAULT NULL,
  `nomor_rekening` varchar(50) DEFAULT NULL,
  `cabang` varchar(100) DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_2e6324986852f7f1a059897041` (`kode_bank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank`
--

LOCK TABLES `bank` WRITE;
/*!40000 ALTER TABLE `bank` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `institusi`
--

DROP TABLE IF EXISTS `institusi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `institusi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_institusi` varchar(50) NOT NULL,
  `nama_institusi` varchar(255) NOT NULL,
  `nama_singkat` varchar(50) DEFAULT NULL,
  `jenis_pt` enum('PTN','PTS','PTN_BH','POLITEKNIK') NOT NULL DEFAULT 'PTS',
  `provinsi_id` bigint unsigned DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `kota` varchar(100) DEFAULT NULL,
  `kode_pos` varchar(10) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `fax` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `nama_rektor` varchar(255) DEFAULT NULL,
  `sk_pendirian` varchar(255) DEFAULT NULL,
  `tanggal_sk_pendirian` date DEFAULT NULL,
  `status` enum('AKTIF','TIDAK_AKTIF','MERGER') NOT NULL DEFAULT 'AKTIF',
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_aed246a35f342c56640d0dea7e` (`kode_institusi`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institusi`
--

LOCK TABLES `institusi` WRITE;
/*!40000 ALTER TABLE `institusi` DISABLE KEYS */;
INSERT INTO `institusi` VALUES (1,'UNI9874','Universitas Riau Indonesia','URI','PTS',NULL,'Jl. Pekanbaru No. 10, Riau',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AKTIF',1,'2026-04-07 15:23:09.898536','2026-04-07 15:23:09.898536'),(2,'POL2838','Politeknik Elektronika Negeri Surabaya','PENS','POLITEKNIK',NULL,'msdkjsahDNJKshdjkd',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'AKTIF',1,'2026-04-07 15:29:42.851624','2026-04-07 15:29:42.851624');
/*!40000 ALTER TABLE `institusi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jenjang`
--

DROP TABLE IF EXISTS `jenjang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jenjang` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_jenjang` varchar(10) NOT NULL,
  `nama_jenjang` varchar(50) NOT NULL,
  `deskripsi` text,
  `urutan` int NOT NULL DEFAULT '0',
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_97746a2718e3945802e862729c` (`kode_jenjang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jenjang`
--

LOCK TABLES `jenjang` WRITE;
/*!40000 ALTER TABLE `jenjang` DISABLE KEYS */;
/*!40000 ALTER TABLE `jenjang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keputusan_ma`
--

DROP TABLE IF EXISTS `keputusan_ma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keputusan_ma` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `pengesahan_al_id` bigint unsigned DEFAULT NULL,
  `nomor_sidang` varchar(100) DEFAULT NULL,
  `tanggal_sidang` date DEFAULT NULL,
  `status` enum('PENDING','DIBAHAS','DISETUJUI','DITOLAK') NOT NULL DEFAULT 'PENDING',
  `peringkat_final` varchar(50) DEFAULT NULL,
  `nilai_final` decimal(5,2) DEFAULT NULL,
  `masa_berlaku` int DEFAULT NULL,
  `hasil_keputusan` text,
  `rekomendasi` text,
  `catatan` text,
  `diputuskan_oleh` bigint unsigned DEFAULT NULL,
  `notulen_sidang` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_752099c895d84954b865a05415` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keputusan_ma`
--

LOCK TABLES `keputusan_ma` WRITE;
/*!40000 ALTER TABLE `keputusan_ma` DISABLE KEYS */;
/*!40000 ALTER TABLE `keputusan_ma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `klaster_ilmu`
--

DROP TABLE IF EXISTS `klaster_ilmu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `klaster_ilmu` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_klaster` varchar(20) NOT NULL,
  `nama_klaster` varchar(255) NOT NULL,
  `deskripsi` text,
  `parent_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_a13d0eb9cf8a9645e312035f96` (`kode_klaster`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `klaster_ilmu`
--

LOCK TABLES `klaster_ilmu` WRITE;
/*!40000 ALTER TABLE `klaster_ilmu` DISABLE KEYS */;
/*!40000 ALTER TABLE `klaster_ilmu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `klaster_prodi`
--

DROP TABLE IF EXISTS `klaster_prodi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `klaster_prodi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_klaster` varchar(20) NOT NULL,
  `nama_klaster` varchar(255) NOT NULL,
  `deskripsi` text,
  `klaster_ilmu_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_2b7ac853bfabfa494c4ca30b00` (`kode_klaster`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `klaster_prodi`
--

LOCK TABLES `klaster_prodi` WRITE;
/*!40000 ALTER TABLE `klaster_prodi` DISABLE KEYS */;
/*!40000 ALTER TABLE `klaster_prodi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `klaster_profesi`
--

DROP TABLE IF EXISTS `klaster_profesi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `klaster_profesi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_klaster` varchar(20) NOT NULL,
  `nama_klaster` varchar(255) NOT NULL,
  `deskripsi` text,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_0be596c18994fd2483d73ae88b` (`kode_klaster`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `klaster_profesi`
--

LOCK TABLES `klaster_profesi` WRITE;
/*!40000 ALTER TABLE `klaster_profesi` DISABLE KEYS */;
/*!40000 ALTER TABLE `klaster_profesi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `komite_evaluasi`
--

DROP TABLE IF EXISTS `komite_evaluasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `komite_evaluasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nip` varchar(50) DEFAULT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `gelar_depan` varchar(50) DEFAULT NULL,
  `gelar_belakang` varchar(100) DEFAULT NULL,
  `jabatan` enum('KETUA','WAKIL_KETUA','SEKRETARIS','ANGGOTA') NOT NULL DEFAULT 'ANGGOTA',
  `email` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `institusi_asal` varchar(255) DEFAULT NULL,
  `bidang_keahlian` varchar(255) DEFAULT NULL,
  `klaster_ilmu_id` bigint unsigned DEFAULT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_berakhir` date DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_9e9c8c689a488b782fe2af0d17` (`nip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `komite_evaluasi`
--

LOCK TABLES `komite_evaluasi` WRITE;
/*!40000 ALTER TABLE `komite_evaluasi` DISABLE KEYS */;
/*!40000 ALTER TABLE `komite_evaluasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kriteria_penilaian`
--

DROP TABLE IF EXISTS `kriteria_penilaian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kriteria_penilaian` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_kriteria` varchar(20) NOT NULL,
  `nama_kriteria` varchar(255) NOT NULL,
  `deskripsi` text,
  `urutan` int NOT NULL DEFAULT '0',
  `bobot` decimal(5,2) NOT NULL DEFAULT '0.00',
  `parent_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_20c1b13a52ee325a8b8bec4cab` (`kode_kriteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kriteria_penilaian`
--

LOCK TABLES `kriteria_penilaian` WRITE;
/*!40000 ALTER TABLE `kriteria_penilaian` DISABLE KEYS */;
/*!40000 ALTER TABLE `kriteria_penilaian` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laporan_asesmen`
--

DROP TABLE IF EXISTS `laporan_asesmen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laporan_asesmen` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `asesor_id` bigint unsigned NOT NULL,
  `jenis_laporan` enum('ASESMEN_KECUKUPAN','ASESMEN_LAPANGAN','BERITA_ACARA') NOT NULL,
  `nomor_laporan` varchar(100) DEFAULT NULL,
  `tanggal_laporan` date DEFAULT NULL,
  `ringkasan` text,
  `rekomendasi` text,
  `nilai_total` decimal(5,2) DEFAULT NULL,
  `status` enum('DRAFT','SUBMITTED','REVIEWED','APPROVED','REJECTED') NOT NULL DEFAULT 'DRAFT',
  `file_url` varchar(255) DEFAULT NULL,
  `ipfs_hash` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_4ae9377644d1980fac5223b8fb` (`asesor_id`),
  KEY `IDX_70bd7800710a5de491a3465d26` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laporan_asesmen`
--

LOCK TABLES `laporan_asesmen` WRITE;
/*!40000 ALTER TABLE `laporan_asesmen` DISABLE KEYS */;
/*!40000 ALTER TABLE `laporan_asesmen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `majelis_akreditasi`
--

DROP TABLE IF EXISTS `majelis_akreditasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `majelis_akreditasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nip` varchar(50) DEFAULT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `gelar_depan` varchar(50) DEFAULT NULL,
  `gelar_belakang` varchar(100) DEFAULT NULL,
  `jabatan` enum('KETUA','WAKIL_KETUA','SEKRETARIS','ANGGOTA') NOT NULL DEFAULT 'ANGGOTA',
  `email` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `institusi_asal` varchar(255) DEFAULT NULL,
  `bidang_keahlian` varchar(255) DEFAULT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_berakhir` date DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_d0014cf406a6acbd6e19fb3ef2` (`nip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `majelis_akreditasi`
--

LOCK TABLES `majelis_akreditasi` WRITE;
/*!40000 ALTER TABLE `majelis_akreditasi` DISABLE KEYS */;
/*!40000 ALTER TABLE `majelis_akreditasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pembayaran`
--

DROP TABLE IF EXISTS `pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pembayaran` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `skema_id` bigint unsigned DEFAULT NULL,
  `nomor_invoice` varchar(100) NOT NULL,
  `tanggal_invoice` date NOT NULL,
  `tanggal_jatuh_tempo` date NOT NULL,
  `jumlah_tagihan` decimal(15,2) NOT NULL,
  `jumlah_dibayar` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` enum('PENDING','PAID','VERIFIED','REJECTED','REFUNDED') NOT NULL DEFAULT 'PENDING',
  `metode_pembayaran` enum('BANK_TRANSFER','VIRTUAL_ACCOUNT','QRIS') DEFAULT NULL,
  `bank_id` bigint unsigned DEFAULT NULL,
  `nomor_rekening_tujuan` varchar(50) DEFAULT NULL,
  `tanggal_bayar` datetime DEFAULT NULL,
  `bukti_bayar_url` varchar(255) DEFAULT NULL,
  `verified_by` bigint unsigned DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `catatan` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_377f36460e85dd1731d5aaf388` (`nomor_invoice`),
  KEY `IDX_4c6ce558539ef4a9dfa59e280c` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pembayaran`
--

LOCK TABLES `pembayaran` WRITE;
/*!40000 ALTER TABLE `pembayaran` DISABLE KEYS */;
/*!40000 ALTER TABLE `pembayaran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `penawaran_asesor`
--

DROP TABLE IF EXISTS `penawaran_asesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `penawaran_asesor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `asesor_id` bigint unsigned NOT NULL,
  `jenis_asesmen` varchar(50) NOT NULL DEFAULT 'AK',
  `status` enum('DRAFT','DIKIRIM','DITERIMA','DITOLAK','EXPIRED') NOT NULL DEFAULT 'DRAFT',
  `tanggal_penawaran` datetime DEFAULT NULL,
  `tanggal_batas_respon` datetime DEFAULT NULL,
  `catatan` text,
  `ditawarkan_oleh` bigint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_b98d2b1dff6725ee6a1f3e9e5d` (`asesor_id`),
  KEY `IDX_48318dad9a23a6626078325890` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penawaran_asesor`
--

LOCK TABLES `penawaran_asesor` WRITE;
/*!40000 ALTER TABLE `penawaran_asesor` DISABLE KEYS */;
/*!40000 ALTER TABLE `penawaran_asesor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengesahan_ak`
--

DROP TABLE IF EXISTS `pengesahan_ak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengesahan_ak` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `laporan_id` bigint unsigned DEFAULT NULL,
  `nomor_pengesahan` varchar(100) DEFAULT NULL,
  `tanggal_pengesahan` datetime DEFAULT NULL,
  `status` enum('PENDING','DISAHKAN','DITOLAK','REVISI') NOT NULL DEFAULT 'PENDING',
  `nilai_ak` decimal(5,2) DEFAULT NULL,
  `hasil_evaluasi` text,
  `catatan` text,
  `disahkan_oleh` bigint unsigned DEFAULT NULL,
  `lanjut_ke_al` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_481f1fee8f972653eb4a83290f` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengesahan_ak`
--

LOCK TABLES `pengesahan_ak` WRITE;
/*!40000 ALTER TABLE `pengesahan_ak` DISABLE KEYS */;
/*!40000 ALTER TABLE `pengesahan_ak` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengesahan_al`
--

DROP TABLE IF EXISTS `pengesahan_al`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengesahan_al` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `laporan_id` bigint unsigned DEFAULT NULL,
  `tanggapan_id` bigint unsigned DEFAULT NULL,
  `nomor_pengesahan` varchar(100) DEFAULT NULL,
  `tanggal_pengesahan` datetime DEFAULT NULL,
  `status` enum('PENDING','DISAHKAN','DITOLAK','REVISI') NOT NULL DEFAULT 'PENDING',
  `nilai_al` decimal(5,2) DEFAULT NULL,
  `nilai_final` decimal(5,2) DEFAULT NULL,
  `hasil_evaluasi` text,
  `catatan` text,
  `rekomendasi_peringkat` varchar(50) DEFAULT NULL,
  `disahkan_oleh` bigint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_e9c9b863e17bb2c905984959b2` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengesahan_al`
--

LOCK TABLES `pengesahan_al` WRITE;
/*!40000 ALTER TABLE `pengesahan_al` DISABLE KEYS */;
/*!40000 ALTER TABLE `pengesahan_al` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodi`
--

DROP TABLE IF EXISTS `prodi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_prodi` varchar(50) NOT NULL,
  `nama_prodi` varchar(255) NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `klaster_ilmu_id` bigint unsigned DEFAULT NULL,
  `klaster_prodi_id` bigint unsigned DEFAULT NULL,
  `sk_pendirian` varchar(255) DEFAULT NULL,
  `tanggal_sk_pendirian` date DEFAULT NULL,
  `sk_operasional` varchar(255) DEFAULT NULL,
  `tanggal_sk_operasional` date DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `nama_kaprodi` varchar(255) DEFAULT NULL,
  `nidn_kaprodi` varchar(50) DEFAULT NULL,
  `jumlah_mahasiswa` int NOT NULL DEFAULT '0',
  `jumlah_dosen` int NOT NULL DEFAULT '0',
  `status` enum('AKTIF','TIDAK_AKTIF','PEMBINAAN') NOT NULL DEFAULT 'AKTIF',
  `peringkat_akreditasi_terakhir` varchar(50) DEFAULT NULL,
  `tanggal_akreditasi_berakhir` date DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_fe7d86a413c7482f76dbbf7f2b` (`kode_prodi`),
  KEY `IDX_1442d57b031da3ba9b50e551e4` (`institusi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodi`
--

LOCK TABLES `prodi` WRITE;
/*!40000 ALTER TABLE `prodi` DISABLE KEYS */;
/*!40000 ALTER TABLE `prodi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provinsi`
--

DROP TABLE IF EXISTS `provinsi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinsi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_provinsi` varchar(10) NOT NULL,
  `nama_provinsi` varchar(100) NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_74d087a58f4cd25fc6552c3620` (`kode_provinsi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinsi`
--

LOCK TABLES `provinsi` WRITE;
/*!40000 ALTER TABLE `provinsi` DISABLE KEYS */;
/*!40000 ALTER TABLE `provinsi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrasi_akreditasi`
--

DROP TABLE IF EXISTS `registrasi_akreditasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrasi_akreditasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prodi_id` bigint unsigned NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `tahun_akademik` varchar(10) NOT NULL,
  `tanggal_registrasi` date NOT NULL,
  `status` enum('draft','submitted','verified','approved','rejected','cancelled') NOT NULL DEFAULT 'draft',
  `nomor_registrasi` varchar(255) DEFAULT NULL,
  `jenis_akreditasi` varchar(100) NOT NULL,
  `keterangan` text,
  `user_id` bigint unsigned DEFAULT NULL,
  `tanggal_verifikasi` datetime DEFAULT NULL,
  `verifikator_id` bigint unsigned DEFAULT NULL,
  `catatan_verifikasi` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registrasi_akreditasi`
--

LOCK TABLES `registrasi_akreditasi` WRITE;
/*!40000 ALTER TABLE `registrasi_akreditasi` DISABLE KEYS */;
/*!40000 ALTER TABLE `registrasi_akreditasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrasi_prodi_baru`
--

DROP TABLE IF EXISTS `registrasi_prodi_baru`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrasi_prodi_baru` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `institusi_id` bigint unsigned NOT NULL,
  `nama_prodi` varchar(255) NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `klaster_ilmu_id` bigint unsigned DEFAULT NULL,
  `jenis_prodi` enum('REGULER','PJJ','PTNBH','NON_PTNBH') NOT NULL DEFAULT 'REGULER',
  `status` enum('DRAFT','SUBMITTED','VALIDASI','DITERIMA','DITOLAK') NOT NULL DEFAULT 'DRAFT',
  `tanggal_pengajuan` datetime DEFAULT NULL,
  `sk_pendirian` varchar(255) DEFAULT NULL,
  `tanggal_sk_pendirian` date DEFAULT NULL,
  `nama_kaprodi` varchar(255) DEFAULT NULL,
  `nidn_kaprodi` varchar(50) DEFAULT NULL,
  `deskripsi` text,
  `file_dokumen_url` varchar(255) DEFAULT NULL,
  `diajukan_oleh` bigint unsigned DEFAULT NULL,
  `catatan` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_3c4a4c7823a0f22ca69a9a3d37` (`institusi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registrasi_prodi_baru`
--

LOCK TABLES `registrasi_prodi_baru` WRITE;
/*!40000 ALTER TABLE `registrasi_prodi_baru` DISABLE KEYS */;
/*!40000 ALTER TABLE `registrasi_prodi_baru` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respon_asesor`
--

DROP TABLE IF EXISTS `respon_asesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respon_asesor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `penawaran_id` bigint unsigned NOT NULL,
  `asesor_id` bigint unsigned NOT NULL,
  `status` enum('PENDING','DITERIMA','DITOLAK') NOT NULL DEFAULT 'PENDING',
  `tanggal_respon` datetime DEFAULT NULL,
  `alasan_penolakan` text,
  `konfirmasi_ketersediaan` tinyint NOT NULL DEFAULT '0',
  `catatan` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_b981bf51424680363797ba72d0` (`asesor_id`),
  KEY `IDX_92a4f849d16e845b572ee326f0` (`penawaran_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respon_asesor`
--

LOCK TABLES `respon_asesor` WRITE;
/*!40000 ALTER TABLE `respon_asesor` DISABLE KEYS */;
/*!40000 ALTER TABLE `respon_asesor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `riwayat_sk`
--

DROP TABLE IF EXISTS `riwayat_sk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `riwayat_sk` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prodi_id` bigint unsigned NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `no_sk` varchar(255) NOT NULL,
  `tahun_sk` smallint unsigned NOT NULL,
  `jenis_sk` varchar(255) NOT NULL,
  `peringkat` varchar(255) NOT NULL,
  `berlaku_mulai` date NOT NULL,
  `berakhir_pada` date DEFAULT NULL,
  `status_sk_id` tinyint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `riwayat_sk`
--

LOCK TABLES `riwayat_sk` WRITE;
/*!40000 ALTER TABLE `riwayat_sk` DISABLE KEYS */;
/*!40000 ALTER TABLE `riwayat_sk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sekretariat`
--

DROP TABLE IF EXISTS `sekretariat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sekretariat` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nip` varchar(50) DEFAULT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `jabatan` enum('KEPALA','WAKIL_KEPALA','STAFF','ADMIN') NOT NULL DEFAULT 'STAFF',
  `email` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `divisi` varchar(100) DEFAULT NULL,
  `tanggal_bergabung` date DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_ce9d80e758948367465ee8ff02` (`nip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sekretariat`
--

LOCK TABLES `sekretariat` WRITE;
/*!40000 ALTER TABLE `sekretariat` DISABLE KEYS */;
/*!40000 ALTER TABLE `sekretariat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sinkronisasi_banpt`
--

DROP TABLE IF EXISTS `sinkronisasi_banpt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sinkronisasi_banpt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `sk_id` bigint unsigned DEFAULT NULL,
  `status` enum('PENDING','SYNCING','SYNCED','FAILED') NOT NULL DEFAULT 'PENDING',
  `tanggal_sinkronisasi` datetime DEFAULT NULL,
  `response_banpt` text,
  `nomor_registrasi_banpt` varchar(100) DEFAULT NULL,
  `error_message` text,
  `retry_count` int NOT NULL DEFAULT '0',
  `last_retry_at` datetime DEFAULT NULL,
  `synced_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_11d0a7ac46da02916f5f0bd84f` (`sk_id`),
  KEY `IDX_20c0aa83259561775288d42e59` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sinkronisasi_banpt`
--

LOCK TABLES `sinkronisasi_banpt` WRITE;
/*!40000 ALTER TABLE `sinkronisasi_banpt` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinkronisasi_banpt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sk`
--

DROP TABLE IF EXISTS `sk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sk` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prodi_id` bigint unsigned NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `jenjang_id` bigint unsigned NOT NULL,
  `no_sk` varchar(255) NOT NULL,
  `tahun_sk` smallint unsigned NOT NULL,
  `jenis_sk` varchar(255) NOT NULL,
  `peringkat` varchar(255) NOT NULL,
  `berlaku_mulai` date NOT NULL,
  `berakhir_pada` date DEFAULT NULL,
  `kode_pt` varchar(255) DEFAULT NULL,
  `id_sp` varchar(255) DEFAULT NULL,
  `kode_ps` varchar(255) DEFAULT NULL,
  `id_sms` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sk`
--

LOCK TABLES `sk` WRITE;
/*!40000 ALTER TABLE `sk` DISABLE KEYS */;
/*!40000 ALTER TABLE `sk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sk_akreditasi`
--

DROP TABLE IF EXISTS `sk_akreditasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sk_akreditasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `keputusan_ma_id` bigint unsigned DEFAULT NULL,
  `nomor_sk` varchar(100) NOT NULL,
  `tanggal_sk` date NOT NULL,
  `tanggal_berlaku` date NOT NULL,
  `tanggal_berakhir` date NOT NULL,
  `peringkat` varchar(50) NOT NULL,
  `nilai_akreditasi` decimal(5,2) NOT NULL,
  `status` enum('DRAFT','GENERATED','SIGNED','PUBLISHED','REVOKED') NOT NULL DEFAULT 'DRAFT',
  `file_sk_url` varchar(255) DEFAULT NULL,
  `ipfs_hash` varchar(100) DEFAULT NULL,
  `blockchain_tx_hash` varchar(100) DEFAULT NULL,
  `blockchain_block_number` bigint DEFAULT NULL,
  `ditandatangani_oleh` varchar(255) DEFAULT NULL,
  `jabatan_penandatangan` varchar(255) DEFAULT NULL,
  `catatan` text,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_45c6e75fffc0075f0c933aa830` (`nomor_sk`),
  KEY `IDX_c4065ef15f8867e4b36757c4a9` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sk_akreditasi`
--

LOCK TABLES `sk_akreditasi` WRITE;
/*!40000 ALTER TABLE `sk_akreditasi` DISABLE KEYS */;
/*!40000 ALTER TABLE `sk_akreditasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skema_pembayaran`
--

DROP TABLE IF EXISTS `skema_pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skema_pembayaran` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_skema` varchar(20) NOT NULL,
  `nama_skema` varchar(255) NOT NULL,
  `tipe` enum('REGULER','PJJ','PRODI_BARU') NOT NULL DEFAULT 'REGULER',
  `jenjang_id` bigint unsigned DEFAULT NULL,
  `biaya_pendaftaran` decimal(15,2) NOT NULL DEFAULT '0.00',
  `biaya_asesmen_kecukupan` decimal(15,2) NOT NULL DEFAULT '0.00',
  `biaya_asesmen_lapangan` decimal(15,2) NOT NULL DEFAULT '0.00',
  `biaya_sk` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total_biaya` decimal(15,2) NOT NULL DEFAULT '0.00',
  `keterangan` text,
  `berlaku_mulai` date DEFAULT NULL,
  `berlaku_sampai` date DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_db0de0f65e2e07fcde873c2f78` (`kode_skema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skema_pembayaran`
--

LOCK TABLES `skema_pembayaran` WRITE;
/*!40000 ALTER TABLE `skema_pembayaran` DISABLE KEYS */;
/*!40000 ALTER TABLE `skema_pembayaran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_institusi`
--

DROP TABLE IF EXISTS `status_institusi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_institusi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `status_institusi` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_institusi`
--

LOCK TABLES `status_institusi` WRITE;
/*!40000 ALTER TABLE `status_institusi` DISABLE KEYS */;
/*!40000 ALTER TABLE `status_institusi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_sk`
--

DROP TABLE IF EXISTS `status_sk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_sk` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_status` varchar(20) NOT NULL,
  `nama_status` varchar(100) NOT NULL,
  `deskripsi` text,
  `warna` varchar(20) DEFAULT NULL,
  `urutan` int NOT NULL DEFAULT '0',
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_df919e91aa72195b02f60bd92e` (`kode_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_sk`
--

LOCK TABLES `status_sk` WRITE;
/*!40000 ALTER TABLE `status_sk` DISABLE KEYS */;
/*!40000 ALTER TABLE `status_sk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tanggapan_al`
--

DROP TABLE IF EXISTS `tanggapan_al`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tanggapan_al` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `laporan_id` bigint unsigned NOT NULL,
  `prodi_id` bigint unsigned NOT NULL,
  `tanggapan` text,
  `bukti_pendukung` text,
  `tanggal_submit` datetime DEFAULT NULL,
  `status` enum('DRAFT','SUBMITTED','REVIEWED') NOT NULL DEFAULT 'DRAFT',
  `file_url` varchar(255) DEFAULT NULL,
  `ipfs_hash` varchar(100) DEFAULT NULL,
  `submitted_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_934b821036e027a0b0236aeb28` (`laporan_id`),
  KEY `IDX_a19d68d888683a204a7249b545` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanggapan_al`
--

LOCK TABLES `tanggapan_al` WRITE;
/*!40000 ALTER TABLE `tanggapan_al` DISABLE KEYS */;
/*!40000 ALTER TABLE `tanggapan_al` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenants` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_2310ecc5cb8be427097154b18fc` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umpan_balik`
--

DROP TABLE IF EXISTS `umpan_balik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umpan_balik` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `akreditasi_id` bigint unsigned NOT NULL,
  `dari_user_id` bigint unsigned NOT NULL,
  `untuk_user_id` bigint unsigned DEFAULT NULL,
  `jenis_feedback` enum('PRODI_TO_ASESOR','ASESOR_TO_PRODI','PRODI_TO_LAMTEK') NOT NULL,
  `rating` int NOT NULL DEFAULT '0',
  `komentar` text,
  `aspek_profesionalisme` int DEFAULT NULL,
  `aspek_komunikasi` int DEFAULT NULL,
  `aspek_kompetensi` int DEFAULT NULL,
  `saran` text,
  `tanggal_submit` datetime DEFAULT NULL,
  `is_anonymous` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_16980c880bdb2c8f324af41933` (`akreditasi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umpan_balik`
--

LOCK TABLES `umpan_balik` WRITE;
/*!40000 ALTER TABLE `umpan_balik` DISABLE KEYS */;
/*!40000 ALTER TABLE `umpan_balik` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umpan_balik_asesor`
--

DROP TABLE IF EXISTS `umpan_balik_asesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umpan_balik_asesor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `al_id` bigint unsigned NOT NULL,
  `asesor_id` bigint unsigned NOT NULL,
  `1_1` tinyint DEFAULT NULL,
  `1_2` varchar(255) DEFAULT NULL,
  `1_3` varchar(255) DEFAULT NULL,
  `1_4` tinyint DEFAULT NULL,
  `1_5_1` varchar(255) DEFAULT NULL,
  `1_5_2` varchar(255) DEFAULT NULL,
  `1_6_1` varchar(255) DEFAULT NULL,
  `1_6_2` varchar(255) DEFAULT NULL,
  `1_7` tinyint DEFAULT NULL,
  `1_8` varchar(255) DEFAULT NULL,
  `1_9` tinyint DEFAULT NULL,
  `1_10` tinyint DEFAULT NULL,
  `1_11` tinyint DEFAULT NULL,
  `1_12` tinyint DEFAULT NULL,
  `2_1_1` varchar(255) DEFAULT NULL,
  `2_1_2` varchar(255) DEFAULT NULL,
  `2_3` tinyint DEFAULT NULL,
  `2_4` tinyint DEFAULT NULL,
  `2_5` tinyint DEFAULT NULL,
  `2_6` tinyint DEFAULT NULL,
  `2_7` tinyint DEFAULT NULL,
  `2_8` text,
  `2_9` tinyint DEFAULT NULL,
  `2_10_1` varchar(255) DEFAULT NULL,
  `2_10_2` varchar(255) DEFAULT NULL,
  `3_1` tinyint DEFAULT NULL,
  `3_2` tinyint DEFAULT NULL,
  `3_3` tinyint DEFAULT NULL,
  `3_4` tinyint DEFAULT NULL,
  `3_5_1` int DEFAULT NULL,
  `3_5_2` text,
  `3_6` text,
  `nama_fakultas` varchar(255) DEFAULT NULL,
  `lokasi_pengisi` varchar(255) DEFAULT NULL,
  `nama_pengisi` varchar(255) DEFAULT NULL,
  `jabatan_pengisi` varchar(255) DEFAULT NULL,
  `tanggal_pengisian` date DEFAULT NULL,
  `rekomendasi_dewan_pengawas` text,
  `catatan_dewan_pengawas` text,
  `syarat_ketentuan_disetujui` tinyint DEFAULT NULL,
  `wkt_syarat_ketentuan_disetujui` datetime DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umpan_balik_asesor`
--

LOCK TABLES `umpan_balik_asesor` WRITE;
/*!40000 ALTER TABLE `umpan_balik_asesor` DISABLE KEYS */;
/*!40000 ALTER TABLE `umpan_balik_asesor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upps`
--

DROP TABLE IF EXISTS `upps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `upps` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_upps` varchar(50) NOT NULL,
  `nama_upps` varchar(255) NOT NULL,
  `institusi_id` bigint unsigned NOT NULL,
  `nama_pimpinan` varchar(255) DEFAULT NULL,
  `jabatan_pimpinan` varchar(100) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_958a72e8299f6088e4fa3cd402` (`kode_upps`),
  KEY `IDX_673aef98f65d1bc091fdd4b5e2` (`institusi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upps`
--

LOCK TABLES `upps` WRITE;
/*!40000 ALTER TABLE `upps` DISABLE KEYS */;
/*!40000 ALTER TABLE `upps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `tenant_id` bigint unsigned DEFAULT NULL,
  `prodi_id` bigint unsigned DEFAULT NULL,
  `institusi_id` bigint unsigned DEFAULT NULL,
  `asesor_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `last_login` datetime DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `role` enum('ADMIN','SEKRETARIAT','KOMITE_EVALUASI','MAJELIS_AKREDITASI','ASESOR','PRODI','UPPS','VALIDATOR') NOT NULL DEFAULT 'PRODI',
  `name` varchar(255) NOT NULL,
  `tenantId` bigint unsigned DEFAULT NULL,
  `noIdentitas` varchar(255) DEFAULT NULL,
  `noSertifikatEdukatif` varchar(255) DEFAULT NULL,
  `isActive` tinyint NOT NULL DEFAULT '1',
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_97672ac88f789774dd47f7c8be` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test@example.com','$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/LLG','Test User',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'PRODI','',NULL,NULL,NULL,1,'2026-04-08 03:46:53.698720','2026-04-08 03:46:53.776191','2026-04-08 03:46:53.867212','2026-04-08 03:46:53.948726'),(2,'newuser@test.com','$2b$10$uP1DMp9gsAWY4K530VGdLOhlfV0.czu8GGFMSyoL5fq9yn.2OoiSK','New User',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'PRODI','',NULL,NULL,NULL,1,'2026-04-08 03:46:53.698720','2026-04-08 03:46:53.776191','2026-04-08 03:46:53.867212','2026-04-08 03:46:53.948726'),(3,'daffa@gmail.com','$2b$10$mdPAo7Hfy9tkmLx2Xmopw.efQt7ZshwtUIP7fMTQi7I0F3KaX669C','Daffa',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'PRODI','',NULL,NULL,NULL,1,'2026-04-08 03:46:53.698720','2026-04-08 03:46:53.776191','2026-04-08 03:46:53.867212','2026-04-08 03:46:53.948726'),(4,'rini.andhini@uniro.ac.id','$2b$10$9X4ybnSJAOuqMKkDAlEbyeSWfLwN78u8KI6LkLhzs97aE8pdqo38u','Dr. Rini Andhini',NULL,NULL,NULL,NULL,1,NULL,NULL,'083456789012','PRODI','',NULL,NULL,NULL,1,'2026-04-08 03:46:53.698720','2026-04-08 03:46:53.776191','2026-04-08 03:46:53.867212','2026-04-08 03:46:53.948726'),(5,'praaji12@gmail.com','$2b$10$F3Xo8YHVMPmFtVGDTsWSD.IRrAIpIUaRG2NG03wyNYQTjCFtvPdxy','Damar Galih AJi Pradana',NULL,NULL,NULL,NULL,1,NULL,NULL,'+6289601321118','PRODI','',NULL,NULL,NULL,1,'2026-04-08 03:46:53.698720','2026-04-08 03:46:53.776191','2026-04-08 03:46:53.867212','2026-04-08 03:46:53.948726');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validator`
--

DROP TABLE IF EXISTS `validator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validator` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `registrasi_prodi_baru_id` bigint unsigned NOT NULL,
  `validator_user_id` bigint unsigned NOT NULL,
  `status` enum('PENDING','ASSIGNED','IN_PROGRESS','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `tanggal_penugasan` datetime DEFAULT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `hasil_validasi` text,
  `rekomendasi` text,
  `is_valid` tinyint DEFAULT NULL,
  `catatan` text,
  `ditugaskan_oleh` bigint unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `IDX_11495a07d9f10cc39ba69c3beb` (`validator_user_id`),
  KEY `IDX_46351e0b802edb39a268f1afb9` (`registrasi_prodi_baru_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validator`
--

LOCK TABLES `validator` WRITE;
/*!40000 ALTER TABLE `validator` DISABLE KEYS */;
/*!40000 ALTER TABLE `validator` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08  4:01:52
