import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

export enum RoleUser {
  ADMIN = 'ADMIN',
  SEKRETARIAT = 'SEKRETARIAT',
  KOMITE_EVALUASI = 'KOMITE_EVALUASI',
  MAJELIS_AKREDITASI = 'MAJELIS_AKREDITASI',
  ASESOR = 'ASESOR',
  PRODI = 'PRODI',
  UPPS = 'UPPS',
  VALIDATOR = 'VALIDATOR',
}

@Entity('users')
@Index(['email'], { unique: true })
export class User {
  @PrimaryGeneratedColumn('increment', { type: 'bigint', unsigned: true })
  id: number;

  @Column({ length: 255 })
  nama: string;

  @Column({ length: 255 })
  email: string;

  @Column({ length: 255 })
  password: string;

  @Column({ type: 'enum', enum: RoleUser, default: RoleUser.PRODI })
  role: RoleUser;

  @Column({ name: 'tenant_id', type: 'bigint', unsigned: true, nullable: true })
  tenantId: number;

  @Column({ name: 'prodi_id', type: 'bigint', unsigned: true, nullable: true })
  prodiId: number;

  @Column({ name: 'institusi_id', type: 'bigint', unsigned: true, nullable: true })
  institusiId: number;

  @Column({ name: 'asesor_id', type: 'bigint', unsigned: true, nullable: true })
  asesorId: number;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'last_login', type: 'datetime', nullable: true })
  lastLogin: Date;

  @Column({ name: 'avatar_url', length: 255, nullable: true })
  avatarUrl: string;

  @Column({ length: 50, nullable: true })
  phone: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
