import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { DataSource } from 'typeorm';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);
  
  // Check database connection
  try {
    const dataSource = app.get(DataSource);
    if (!dataSource.isInitialized) {
      await dataSource.initialize();
    }
    const queryRunner = dataSource.createQueryRunner();
    await queryRunner.connect();
    const version = await queryRunner.query('SELECT VERSION() as version');
    logger.log(`✅ Database connected successfully: ${version[0].version}`);
    await queryRunner.release();
  } catch (error) {
    logger.error(`❌ Database connection failed: ${error.message}`);
    logger.error('Make sure your database is running and credentials in .env are correct');
    process.exit(1);
  }
  
  // Global prefix
  app.setGlobalPrefix('api/v1');
  
  // Validation pipe
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
    forbidNonWhitelisted: true,
  }));
  
  // CORS
  app.enableCors({
    origin: process.env.CORS_ORIGINS?.split(',') || ['http://localhost:3001'],
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });
  
  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('LAM Teknik SaaS API')
    .setDescription('API untuk sistem akreditasi LAM Teknik berbasis Blockchain')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication & Authorization')
    .addTag('tenant', 'Multi-tenant Management')
    .addTag('akreditasi', 'Modul Akreditasi')
    .addTag('asesmen-kecukupan', 'Modul Asesmen Kecukupan')
    .addTag('asesmen-lapangan', 'Modul Asesmen Lapangan')
    .addTag('dokumen', 'Manajemen Dokumen IPFS')
    .addTag('ipfs', 'IPFS Storage Operations')
    .addTag('blockchain', 'Blockchain Operations')
    .addTag('health', 'Health Check')
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);
  
  const port = process.env.PORT || 3000;
  await app.listen(port);
  
  logger.log(`🚀 LAM Teknik SaaS API running on: http://localhost:${port}`);
  logger.log(`📚 Swagger docs: http://localhost:${port}/api/docs`);
  logger.log(`🔐 Auth endpoints: POST /api/v1/auth/login, POST /api/v1/auth/register`);
}

bootstrap();
