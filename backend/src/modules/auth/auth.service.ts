import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { LoginDto, RegisterDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<{ user: any; token: string }> {
    const existingUser = await this.userRepository.findOne({
      where: { email: registerDto.email },
    });

    if (existingUser) {
      throw new BadRequestException('Email sudah terdaftar');
    }

    const hashedPassword = await bcrypt.hash(registerDto.password, 10);

    const user = this.userRepository.create({
      ...registerDto,
      password: hashedPassword,
      role: 'USER',
    });

    const savedUser = await this.userRepository.save(user);
    const token = this.jwtService.sign({
      id: savedUser.id,
      email: savedUser.email,
      tenantId: savedUser.tenantId,
    });

    return {
      user: this.formatUser(savedUser),
      token,
    };
  }

  async login(loginDto: LoginDto): Promise<{ user: any; token: string }> {
    const user = await this.userRepository.findOne({
      where: { email: loginDto.email },
    });

    if (!user) {
      throw new UnauthorizedException('Email atau password salah');
    }

    const passwordMatches = await bcrypt.compare(
      loginDto.password,
      user.password,
    );

    if (!passwordMatches) {
      throw new UnauthorizedException('Email atau password salah');
    }

    const token = this.jwtService.sign({
      id: user.id,
      email: user.email,
      tenantId: user.tenantId,
    });

    return {
      user: this.formatUser(user),
      token,
    };
  }

  async validateUser(id: number): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { id, isActive: true },
    });

    if (!user) {
      throw new UnauthorizedException('User tidak ditemukan');
    }

    return this.formatUser(user);
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
