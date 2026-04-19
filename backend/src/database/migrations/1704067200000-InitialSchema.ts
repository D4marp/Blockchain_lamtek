import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from 'typeorm';

/**
 * Initial database schema migration for LAM Teknik SaaS
 * Creates all core tables with relationships and indices
 * 
 * Tables:
 * - users: User accounts and authentication
 * - tenants: Multi-tenant support
 * - akreditasi: Main accreditation process
 * - asesmen_kecukupan: Document assessment
 * - asesmen_lapangan: Field assessment
 * - dokumen: Document storage with IPFS/blockchain tracking
 * - pembayaran: Payment transactions
 */
export class InitialSchema1704067200000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // ============================================
    // USERS & AUTHENTICATION
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'email',
            type: 'varchar',
            length: '255',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'password',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'firstName',
            type: 'varchar',
            length: '100',
            isNullable: true,
          },
          {
            name: 'lastName',
            type: 'varchar',
            length: '100',
            isNullable: true,
          },
          {
            name: 'role',
            type: 'enum',
            enum: ['admin', 'user', 'assessor', 'reviewer'],
            default: "'user'",
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['active', 'inactive', 'suspended'],
            default: "'active'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_users_email', columnNames: ['email'] }),
          new TableIndex({ name: 'IDX_users_role', columnNames: ['role'] }),
          new TableIndex({ name: 'IDX_users_status', columnNames: ['status'] }),
        ],
      }),
      true,
    );

    // ============================================
    // TENANTS (Multi-tenant)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'tenants',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'name',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'slug',
            type: 'varchar',
            length: '255',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['active', 'inactive'],
            default: "'active'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
      }),
      true,
    );

    // ============================================
    // AKREDITASI (Main Module)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'akreditasi',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'tenantId',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'name',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['draft', 'submitted', 'in_review', 'approved', 'rejected'],
            default: "'draft'",
          },
          {
            name: 'createdBy',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_akreditasi_tenantId', columnNames: ['tenantId'] }),
          new TableIndex({ name: 'IDX_akreditasi_status', columnNames: ['status'] }),
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'akreditasi',
      new TableForeignKey({
        name: 'FK_akreditasi_tenantId',
        columnNames: ['tenantId'],
        referencedTableName: 'tenants',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    // ============================================
    // ASESMEN KECUKUPAN (Document Assessment)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'asesmen_kecukupan',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'akreditasiId',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['pending', 'completed', 'approved', 'rejected'],
            default: "'pending'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_asesmen_kecukupan_akreditasiId', columnNames: ['akreditasiId'] }),
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'asesmen_kecukupan',
      new TableForeignKey({
        name: 'FK_asesmen_kecukupan_akreditasiId',
        columnNames: ['akreditasiId'],
        referencedTableName: 'akreditasi',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    // ============================================
    // ASESMEN LAPANGAN (Field Assessment)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'asesmen_lapangan',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'akreditasiId',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'location',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['pending', 'completed', 'approved', 'rejected'],
            default: "'pending'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_asesmen_lapangan_akreditasiId', columnNames: ['akreditasiId'] }),
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'asesmen_lapangan',
      new TableForeignKey({
        name: 'FK_asesmen_lapangan_akreditasiId',
        columnNames: ['akreditasiId'],
        referencedTableName: 'akreditasi',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    // ============================================
    // DOCUMENTS & BLOCKCHAIN
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'dokumen',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'akreditasiId',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'fileName',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'ipfsHash',
            type: 'varchar',
            length: '255',
            isUnique: true,
            isNullable: true,
          },
          {
            name: 'blockchainHash',
            type: 'varchar',
            length: '255',
            isUnique: true,
            isNullable: true,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['pending', 'ipfs_stored', 'blockchain_recorded', 'verified'],
            default: "'pending'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_dokumen_akreditasiId', columnNames: ['akreditasiId'] }),
          new TableIndex({ name: 'IDX_dokumen_ipfsHash', columnNames: ['ipfsHash'] }),
          new TableIndex({ name: 'IDX_dokumen_blockchainHash', columnNames: ['blockchainHash'] }),
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'dokumen',
      new TableForeignKey({
        name: 'FK_dokumen_akreditasiId',
        columnNames: ['akreditasiId'],
        referencedTableName: 'akreditasi',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    // ============================================
    // PEMBAYARAN (Payment Module)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'pembayaran',
        columns: [
          {
            name: 'id',
            type: 'varchar',
            length: '36',
            isPrimary: true,
          },
          {
            name: 'akreditasiId',
            type: 'varchar',
            length: '36',
            isNullable: false,
          },
          {
            name: 'amount',
            type: 'decimal',
            precision: 12,
            scale: 2,
            isNullable: false,
          },
          {
            name: 'currency',
            type: 'varchar',
            length: '3',
            default: "'IDR'",
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['pending', 'completed', 'failed', 'cancelled'],
            default: "'pending'",
          },
          {
            name: 'transactionHash',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            onUpdate: 'CURRENT_TIMESTAMP',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_pembayaran_akreditasiId', columnNames: ['akreditasiId'] }),
          new TableIndex({ name: 'IDX_pembayaran_status', columnNames: ['status'] }),
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'pembayaran',
      new TableForeignKey({
        name: 'FK_pembayaran_akreditasiId',
        columnNames: ['akreditasiId'],
        referencedTableName: 'akreditasi',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    // ============================================
    // REGISTRASI AKREDITASI (Registration)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'registrasi_akreditasi',
        columns: [
          {
            name: 'id',
            type: 'bigint',
            isGenerated: true,
            generationStrategy: 'increment',
            isPrimary: true,
            unsigned: true,
          },
          {
            name: 'prodi_id',
            type: 'bigint',
            unsigned: true,
            isNullable: false,
          },
          {
            name: 'institusi_id',
            type: 'bigint',
            unsigned: true,
            isNullable: false,
          },
          {
            name: 'tahun_akademik',
            type: 'varchar',
            length: '10',
            isNullable: false,
          },
          {
            name: 'tanggal_registrasi',
            type: 'date',
            isNullable: false,
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['draft', 'submitted', 'verified', 'approved', 'rejected', 'cancelled'],
            default: "'draft'",
          },
          {
            name: 'nomor_registrasi',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'jenis_akreditasi',
            type: 'varchar',
            length: '100',
            isNullable: false,
          },
          {
            name: 'keterangan',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'user_id',
            type: 'bigint',
            unsigned: true,
            isNullable: true,
          },
          {
            name: 'tanggal_verifikasi',
            type: 'datetime',
            isNullable: true,
          },
          {
            name: 'verifikator_id',
            type: 'bigint',
            unsigned: true,
            isNullable: true,
          },
          {
            name: 'catatan_verifikasi',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'datetime',
            precision: 6,
            default: 'CURRENT_TIMESTAMP(6)',
          },
          {
            name: 'updated_at',
            type: 'datetime',
            precision: 6,
            default: 'CURRENT_TIMESTAMP(6)',
            onUpdate: 'CURRENT_TIMESTAMP(6)',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_registrasi_akreditasi_status', columnNames: ['status'] }),
          new TableIndex({ name: 'IDX_registrasi_akreditasi_prodi_id', columnNames: ['prodi_id'] }),
          new TableIndex({ name: 'IDX_registrasi_akreditasi_institusi_id', columnNames: ['institusi_id'] }),
        ],
      }),
      true,
    );

    // ============================================
    // REGISTRASI PRODI BARU (New Study Program Registration)
    // ============================================
    await queryRunner.createTable(
      new Table({
        name: 'registrasi_prodi_baru',
        columns: [
          {
            name: 'id',
            type: 'bigint',
            isGenerated: true,
            generationStrategy: 'increment',
            isPrimary: true,
            unsigned: true,
          },
          {
            name: 'institusi_id',
            type: 'bigint',
            unsigned: true,
            isNullable: false,
          },
          {
            name: 'nama_prodi',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'jenjang_id',
            type: 'bigint',
            unsigned: true,
            isNullable: false,
          },
          {
            name: 'klaster_ilmu_id',
            type: 'bigint',
            unsigned: true,
            isNullable: true,
          },
          {
            name: 'jenis_prodi',
            type: 'enum',
            enum: ['REGULER', 'PJJ', 'PTNBH', 'NON_PTNBH'],
            default: "'REGULER'",
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['DRAFT', 'SUBMITTED', 'VALIDASI', 'DITERIMA', 'DITOLAK'],
            default: "'DRAFT'",
          },
          {
            name: 'tanggal_pengajuan',
            type: 'datetime',
            isNullable: true,
          },
          {
            name: 'sk_pendirian',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'tanggal_sk_pendirian',
            type: 'date',
            isNullable: true,
          },
          {
            name: 'nama_kaprodi',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'nidn_kaprodi',
            type: 'varchar',
            length: '50',
            isNullable: true,
          },
          {
            name: 'deskripsi',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'file_dokumen_url',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'diajukan_oleh',
            type: 'bigint',
            unsigned: true,
            isNullable: true,
          },
          {
            name: 'catatan',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'datetime',
            precision: 6,
            default: 'CURRENT_TIMESTAMP(6)',
          },
          {
            name: 'updated_at',
            type: 'datetime',
            precision: 6,
            default: 'CURRENT_TIMESTAMP(6)',
            onUpdate: 'CURRENT_TIMESTAMP(6)',
          },
        ],
        indices: [
          new TableIndex({ name: 'IDX_registrasi_prodi_baru_status', columnNames: ['status'] }),
          new TableIndex({ name: 'IDX_registrasi_prodi_baru_institusi_id', columnNames: ['institusi_id'] }),
        ],
      }),
      true,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop foreign keys first
    await queryRunner.dropForeignKey('pembayaran', 'FK_pembayaran_akreditasiId');
    await queryRunner.dropForeignKey('dokumen', 'FK_dokumen_akreditasiId');
    await queryRunner.dropForeignKey('asesmen_lapangan', 'FK_asesmen_lapangan_akreditasiId');
    await queryRunner.dropForeignKey('asesmen_kecukupan', 'FK_asesmen_kecukupan_akreditasiId');
    await queryRunner.dropForeignKey('akreditasi', 'FK_akreditasi_tenantId');

    // Drop tables
    await queryRunner.dropTable('registrasi_prodi_baru', true);
    await queryRunner.dropTable('registrasi_akreditasi', true);
    await queryRunner.dropTable('pembayaran', true);
    await queryRunner.dropTable('dokumen', true);
    await queryRunner.dropTable('asesmen_lapangan', true);
    await queryRunner.dropTable('asesmen_kecukupan', true);
    await queryRunner.dropTable('akreditasi', true);
    await queryRunner.dropTable('tenants', true);
    await queryRunner.dropTable('users', true);
  }
}
