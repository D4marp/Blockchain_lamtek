import { Injectable } from '@nestjs/common';
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
  ) {}

  async uploadDokumen(
    kodeAkreditasi: string,
    file: Express.Multer.File,
    tipeDokumen: TipeDokumen,
    metadata?: Record<string, any>,
  ): Promise<{
    ipfsHash: string;
    url: string;
    sha256: string;
    blockchainTxHash?: string;
  }> {
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
