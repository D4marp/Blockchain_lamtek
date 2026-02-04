import { Module } from '@nestjs/common';
import { DokumenController } from './dokumen.controller';
import { DokumenService } from './dokumen.service';
import { IpfsModule } from '../ipfs/ipfs.module';
import { BlockchainModule } from '../blockchain/blockchain.module';

@Module({
  imports: [IpfsModule, BlockchainModule],
  controllers: [DokumenController],
  providers: [DokumenService],
  exports: [DokumenService],
})
export class DokumenModule {}
