import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './modules/auth/entities/user.entity';

async function seedDatabase() {
  const app = await NestFactory.create(AppModule);
  const dataSource = app.get(DataSource);
  
  try {
    console.log('Seeding database...');

    // Create users
    const users = [
      {
        name: 'Admin LAM Teknik',
        email: 'admin@lamtek.ac.id',
        password: await bcrypt.hash('password123', 10),
        role: 'ADMIN',
        tenantId: null,
      },
      {
        name: 'PT Institusi Teknik',
        email: 'koordinator@ui.ac.id',
        password: await bcrypt.hash('password123', 10),
        role: 'INSTITUTION',
        tenantId: 1,
      },
      {
        name: 'Dr. Ahmad Validator',
        email: 'validator@lamtek.ac.id',
        password: await bcrypt.hash('password123', 10),
        role: 'VALIDATOR',
        tenantId: null,
      },
      {
        name: 'Asesor Lapangan',
        email: 'asesor@lamtek.ac.id',
        password: await bcrypt.hash('password123', 10),
        role: 'USER',
        tenantId: null,
      },
    ];

    const userRepository = dataSource.getRepository(User);
    
    for (const userData of users) {
      const exists = await userRepository.findOne({
        where: { email: userData.email },
      });
      
      if (!exists) {
        const user = userRepository.create(userData);
        await userRepository.save(user);
        console.log(`Created user: ${userData.email}`);
      }
    }

    console.log('Database seeding completed!');
  } catch (error) {
    console.error('Error seeding database:', error);
  } finally {
    await app.close();
  }
}

seedDatabase();
