import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('increment', { type: 'bigint', unsigned: true })
  id: number;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 255 })
  password: string;

  @Column({ type: 'enum', enum: ['ADMIN', 'SEKRETARIAT', 'KOMITE_EVALUASI', 'MAJELIS_AKREDITASI', 'ASESOR', 'PRODI', 'UPPS', 'VALIDATOR'], default: 'PRODI' })
  role: string;

  @Column({ type: 'bigint', unsigned: true, nullable: true })
  tenantId: number;

  @Column({ type: 'varchar', length: 255, nullable: true })
  noIdentitas: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  noSertifikatEdukatif: string;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Additional columns that exist in database but managed separately
  @Column({ type: 'varchar', length: 255 })
  nama: string; // Redundant with 'name', kept for compatibility

  @Column({ name: 'tenant_id', type: 'bigint', unsigned: true, nullable: true })
  tenant_id: number; // snake_case version for compatibility

  @Column({ name: 'prodi_id', type: 'bigint', unsigned: true, nullable: true })
  prodi_id: number;

  @Column({ name: 'institusi_id', type: 'bigint', unsigned: true, nullable: true })
  institusi_id: number;

  @Column({ name: 'asesor_id', type: 'bigint', unsigned: true, nullable: true })
  asesor_id: number;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  is_active: boolean;

  @Column({ name: 'last_login', type: 'datetime', nullable: true })
  last_login: Date;

  @Column({ name: 'avatar_url', type: 'varchar', length: 255, nullable: true })
  avatar_url: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  phone: string;
}
