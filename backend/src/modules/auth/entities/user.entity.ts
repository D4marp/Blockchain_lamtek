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

  @Column({ type: 'varchar', length: 50, default: 'USER' })
  role: string; // ADMIN, VALIDATOR, INSTITUTION, USER

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
}
