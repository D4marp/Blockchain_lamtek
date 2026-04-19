import { Injectable, Optional } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'crypto';
import { KafkaService, KafkaTopic } from '../kafka/kafka.service';
import { IpfsService } from '../ipfs/ipfs.service';
import { BlockchainService } from '../blockchain/blockchain.service';

export enum TipeDokumen {
  DOKUMEN_REGISTRASI = 'DOKUMEN_REGISTRASI',
  BUKTI_PEMBAYARAN = 'BUKTI_PEMBAYARAN',
  LAPORAN_EVALUASI_DIRI = 'LAPORAN_EVALUASI_DIRI',
  LAPORAN_KINERJA = 'LAPORAN_KINERJA',
  LAPORAN_AK = 'LAPORAN_AK',
  LAPORAN_AL = 'LAPORAN_AL',
  BERITA_ACARA = 'BERITA_ACARA',
  SURAT_TUGAS = 'SURAT_TUGAS',
  UMPAN_BALIK = 'UMPAN_BALIK',
  TANGGAPAN = 'TANGGAPAN',
  SK_AKREDITASI = 'SK_AKREDITASI',
  SERTIFIKAT = 'SERTIFIKAT',
  LAINNYA = 'LAINNYA',
}

@Injectable()
export class DokumenService {
  constructor(
    private ipfsService: IpfsService,
    private blockchainService: BlockchainService,
    private configService: ConfigService,
    @Optional() private kafkaService?: KafkaService,
  ) {}

  async uploadDokumen(
    kodeAkreditasi: string,
    file: any,
    tipeDokumen: TipeDokumen,
    metadata?: Record<string, any>,
  ): Promise<{
    queued?: boolean;
    referenceId?: string;
    topic?: string;
    message?: string;
    ipfsHash?: string;
    url?: string;
    sha256?: string;
    blockchainTxHash?: string;
  }> {
    const workflowMode = this.configService.get<string>('DATA_FILE_WORKFLOW_MODE', 'sync');

    if (workflowMode === 'kafka' && this.kafkaService?.isKafkaConnected()) {
      const referenceId = randomUUID();

      await this.kafkaService.publishDataFile(
        {
          operation: 'upload',
          referenceId,
          kodeAkreditasi,
          tipeDokumen,
          fileName: file.originalname,
          mimeType: file.mimetype,
          contentBase64: Buffer.from(file.buffer).toString('base64'),
          metadata,
          emittedAt: new Date().toISOString(),
        },
        referenceId,
      );

      return {
        queued: true,
        referenceId,
        topic: KafkaTopic.DATA_FILE,
        message: 'Document queued for Kafka connector workflow',
      };
    }

    // Upload to IPFS
    const { ipfsHash, url, sha256 } = await this.ipfsService.uploadFile(file);

    // Record to blockchain
    let blockchainTxHash: string | undefined;
    try {
      blockchainTxHash = await this.blockchainService.uploadDokumen({
        kodeAkreditasi,
        ipfsHash,
        namaDokumen: file.originalname,
        tipeDokumen,
      });
    } catch (error) {
      console.error('Failed to record document to blockchain:', error);
    }

    return {
      ipfsHash,
      url,
      sha256,
      blockchainTxHash,
    };
  }

  async getDokumenByAkreditasi(kodeAkreditasi: string): Promise<any[]> {
    return this.blockchainService.getDokumen(kodeAkreditasi);
  }

  async verifyDokumen(
    ipfsHash: string,
    expectedSha256: string,
  ): Promise<{ valid: boolean; ipfsHash: string }> {
    const valid = await this.ipfsService.verifyFileIntegrity(ipfsHash, expectedSha256);
    return { valid, ipfsHash };
  }

  async getDokumenFromIpfs(ipfsHash: string): Promise<Buffer> {
    return this.ipfsService.getFile(ipfsHash);
  }
}
