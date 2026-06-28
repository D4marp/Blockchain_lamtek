-- Create tenants table
CREATE TABLE IF NOT EXISTS `tenants` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tenants_slug_unique` (`slug`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Create users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN', 'SEKRETARIAT', 'KOMITE_EVALUASI', 'MAJELIS_AKREDITASI', 'ASESOR', 'PRODI', 'UPPS', 'VALIDATOR', 'INSTITUTION', 'USER') NOT NULL DEFAULT 'PRODI',
  `tenantId` bigint(20) UNSIGNED NULL,
  `noIdentitas` varchar(100) NULL,
  `noSertifikatEdukatif` varchar(100) NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_tenant_id_fk` (`tenantId`),
  CONSTRAINT `users_tenant_id_fk` FOREIGN KEY (`tenantId`) REFERENCES `tenants` (`id`) ON DELETE SET NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Insert test users
INSERT INTO `users` (`name`, `email`, `password`, `role`, `tenantId`, `isActive`) VALUES
('Admin LAM Teknik', 'admin@lamtek.ac.id', '$2a$10$dGQpyMuHJt/ayZaMDF98QuLjLn8O6BKbmT69ZsyDVMs3QhHFNTzU6', 'ADMIN', NULL, 1),
('Test User', 'demo@test.com', '$2a$10$GUVUT4FgN7uWuGLdx1Fbp.k5HN3Epyta2q90vhc1SM.vgYWiVxL8.', 'USER', NULL, 1),
('Validator Asesmen', 'validator@test.com', '$2a$10$GUVUT4FgN7uWuGLdx1Fbp.k5HN3Epyta2q90vhc1SM.vgYWiVxL8.', 'VALIDATOR', NULL, 1),
('Institution Admin', 'institution@test.com', '$2a$10$GUVUT4FgN7uWuGLdx1Fbp.k5HN3Epyta2q90vhc1SM.vgYWiVxL8.', 'INSTITUTION', NULL, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
