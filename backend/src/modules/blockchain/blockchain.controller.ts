import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { BlockchainService } from './blockchain.service';

@ApiTags('blockchain')
@Controller('blockchain')
export class BlockchainController {
  constructor(private readonly blockchainService: BlockchainService) {}

  @Get('info')
  @ApiOperation({ summary: 'Get blockchain network info' })
  async getInfo() {
    return this.blockchainService.getBlockchainInfo();
  }

  @Get('stats')
  @ApiOperation({ summary: 'Get blockchain statistics' })
  async getStats() {
    const [info, totalAkreditasi] = await Promise.all([
      this.blockchainService.getBlockchainInfo(),
      this.blockchainService.getTotalAkreditasi(),
    ]);

    return {
      ...info,
      totalAkreditasi,
    };
  }
}
