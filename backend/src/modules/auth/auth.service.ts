import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { LoginDto, RegisterDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<{ user: any; token: string }> {
    try {
      this.logger.debug(`[REGISTER] Attempting registration for email: ${registerDto.email}`);

      const existingUser = await this.userRepository.findOne({
        where: { email: registerDto.email },
      });

      if (existingUser) {
        this.logger.warn(`[REGISTER] User already exists with email: ${registerDto.email}`);
        throw new BadRequestException('Email sudah terdaftar');
      }

      const hashedPassword = await bcrypt.hash(registerDto.password, 10);
      this.logger.debug(`[REGISTER] Password hashed successfully for ${registerDto.email}`);

      const user = this.userRepository.create({
        ...registerDto,
        password: hashedPassword,
        role: 'USER',
      });

      const savedUser = await this.userRepository.save(user);
      this.logger.log(`[REGISTER] User registered successfully: ${savedUser.id} - ${savedUser.email}`);

      const token = this.jwtService.sign({
        id: savedUser.id,
        email: savedUser.email,
        tenantId: savedUser.tenantId,
      });

      return {
        user: this.formatUser(savedUser),
        token,
      };
    } catch (error) {
      this.logger.error(`[REGISTER] Registration failed: ${error.message}`, error.stack);
      throw error;
    }
  }

  async login(loginDto: LoginDto): Promise<{ user: any; token: string }> {
    try {
      this.logger.debug(`[LOGIN] Login attempt for email: ${loginDto.email}`);

      const user = await this.userRepository.findOne({
        where: { email: loginDto.email },
      });

      if (!user) {
        this.logger.warn(`[LOGIN] User not found with email: ${loginDto.email}`);
        throw new UnauthorizedException('Email atau password salah');
      }

      this.logger.debug(`[LOGIN] User found: ${user.id}, checking password...`);

      const passwordMatches = await bcrypt.compare(
        loginDto.password,
        user.password,
      );

      if (!passwordMatches) {
        this.logger.warn(`[LOGIN] Password mismatch for user: ${loginDto.email}`);
        throw new UnauthorizedException('Email atau password salah');
      }

      this.logger.debug(`[LOGIN] Password verified for user: ${loginDto.email}`);

      if (!user.isActive) {
        this.logger.warn(`[LOGIN] User account is inactive: ${loginDto.email}`);
        throw new UnauthorizedException('Akun Anda tidak aktif');
      }

      const token = this.jwtService.sign({
        id: user.id,
        email: user.email,
        tenantId: user.tenantId,
      });

      this.logger.log(`[LOGIN] Login successful for user: ${user.id} - ${user.email}`);

      return {
        user: this.formatUser(user),
        token,
      };
    } catch (error) {
      this.logger.error(`[LOGIN] Login failed: ${error.message}`, error.stack);
      throw error;
    }
  }

  async validateUser(id: number): Promise<any> {
    try {
      this.logger.debug(`[VALIDATE] Validating user: ${id}`);

      const user = await this.userRepository.findOne({
        where: { id, isActive: true },
      });

      if (!user) {
        this.logger.warn(`[VALIDATE] User not found or inactive: ${id}`);
        throw new UnauthorizedException('User tidak ditemukan');
      }

      this.logger.debug(`[VALIDATE] User validated successfully: ${id}`);
      return this.formatUser(user);
    } catch (error) {
      this.logger.error(`[VALIDATE] Validation failed: ${error.message}`, error.stack);
      throw error;
    }
  }

  async updateProfile(
    id: number,
    data: { name?: string; noIdentitas?: string; noSertifikatEdukatif?: string },
  ): Promise<any> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new UnauthorizedException('User tidak ditemukan');
    }

    Object.assign(user, data);
    const updatedUser = await this.userRepository.save(user);
    return this.formatUser(updatedUser);
  }

  private formatUser(user: User) {
    const { password, ...result } = user;
    return {
      id: result.id,
      name: result.name,
      email: result.email,
      role: result.role,
      tenantId: result.tenantId,
      noIdentitas: result.noIdentitas,
      noSertifikatEdukatif: result.noSertifikatEdukatif,
      isActive: result.isActive,
      createdAt: result.createdAt,
    };
  }
}
