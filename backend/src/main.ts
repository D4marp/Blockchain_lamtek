import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
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
  
  console.log(`🚀 LAM Teknik SaaS API running on: http://localhost:${port}`);
  console.log(`📚 Swagger docs: http://localhost:${port}/api/docs`);
}

bootstrap();
