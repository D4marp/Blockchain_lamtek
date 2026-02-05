import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ethers, Contract, Wallet, JsonRpcProvider, TransactionReceipt } from 'ethers';

// ABI untuk smart contracts (simplified)
const AKREDITASI_REGISTRY_ABI = [
  'function registerAkreditasi(string kodeAkreditasi, uint256 institusiId, uint256 prodiId, uint256 uppsId, uint8 tipe, string ipfsHashDokumen) returns (bool)',
  'function updateStatus(string kodeAkreditasi, uint8 newStatus, string ipfsHashBukti, string keterangan) returns (bool)',
  'function tetapkanPeringkat(string kodeAkreditasi, uint8 peringkat, uint256 nilai, string ipfsHashSK, string ipfsHashSertifikat, uint256 tanggalBerakhir) returns (bool)',
  'function uploadDokumen(string kodeAkreditasi, string ipfsHash, string namaDokumen, string tipeDokumen) returns (bool)',
  'function getAkreditasi(string kodeAkreditasi) view returns (tuple(string kodeAkreditasi, uint256 institusiId, uint256 prodiId, uint256 uppsId, uint8 tipe, uint8 status, uint8 peringkat, uint256 nilaiAkreditasi, string ipfsHashDokumen, string ipfsHashSK, string ipfsHashSertifikat, uint256 tanggalRegistrasi, uint256 tanggalTerakreditasi, uint256 tanggalBerakhir, address registeredBy, bool isActive))',
  'function getAuditLogs(string kodeAkreditasi) view returns (tuple(string kodeAkreditasi, uint8 fromStatus, uint8 toStatus, string ipfsHashBukti, string keterangan, address changedBy, uint256 timestamp)[])',
  'function getDokumen(string kodeAkreditasi) view returns (tuple(string ipfsHash, string namaDokumen, string tipeDokumen, uint256 uploadedAt, address uploadedBy, bool isVerified)[])',
  'function registerTenant(uint256 institusiId, string nama)',
  'function getTotalAkreditasi() view returns (uint256)',
  'event AkreditasiRegistered(string indexed kodeAkreditasi, uint256 indexed institusiId, uint256 indexed prodiId, uint8 tipe, address registeredBy, uint256 timestamp)',
  'event StatusChanged(string indexed kodeAkreditasi, uint8 fromStatus, uint8 toStatus, address changedBy, uint256 timestamp)',
];

@Injectable()
export class BlockchainService implements OnModuleInit {
  private readonly logger = new Logger(BlockchainService.name);
  private provider: JsonRpcProvider;
  private wallet: Wallet;
  private akreditasiContract: Contract;
  private isConnected = false;

  constructor(private configService: ConfigService) {}

  async onModuleInit() {
    try {
      await this.connect();
    } catch (error) {
      this.logger.warn('Blockchain service initialization failed. Continuing without blockchain support.');
      this.logger.debug(error);
    }
  }

  /**
   * Connect to Besu network
   */
  async connect(): Promise<void> {
    try {
      const rpcUrl = this.configService.get('BESU_RPC_URL', 'http://localhost:8545');
      const privateKey = this.configService.get('BLOCKCHAIN_PRIVATE_KEY', '0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63');
      const contractAddress = this.configService.get('AKREDITASI_CONTRACT_ADDRESS');

      this.provider = new JsonRpcProvider(rpcUrl);
      
      // Check connection
      const network = await this.provider.getNetwork();
      this.logger.log(`Connected to blockchain network: ${network.chainId}`);

      this.wallet = new Wallet(privateKey, this.provider);
      this.logger.log(`Wallet address: ${this.wallet.address}`);

      if (contractAddress) {
        this.akreditasiContract = new Contract(
          contractAddress,
          AKREDITASI_REGISTRY_ABI,
          this.wallet
        );
        this.logger.log(`Akreditasi contract loaded at: ${contractAddress}`);
      } else {
        this.logger.warn('No contract address configured');
      }

      this.isConnected = true;
    } catch (error) {
      this.logger.error('Failed to connect to blockchain:', error);
      this.isConnected = false;
    }
  }

  /**
   * Check if connected to blockchain
   */
  isBlockchainConnected(): boolean {
    return this.isConnected;
  }

  /**
   * Get blockchain info
   */
  async getBlockchainInfo(): Promise<any> {
    if (!this.isConnected) {
      return { connected: false };
    }

    const [network, blockNumber, gasPrice] = await Promise.all([
      this.provider.getNetwork(),
      this.provider.getBlockNumber(),
      this.provider.getFeeData(),
    ]);

    return {
      connected: true,
      chainId: network.chainId.toString(),
      blockNumber,
      gasPrice: gasPrice.gasPrice?.toString(),
      walletAddress: this.wallet.address,
    };
  }

  /**
   * Register akreditasi to blockchain
   */
  async registerAkreditasi(data: {
    kodeAkreditasi: string;
    institusiId: number;
    prodiId: number;
    uppsId: number;
    tipe: string;
    ipfsHashDokumen?: string;
  }): Promise<string> {
    if (!this.akreditasiContract) {
      this.logger.warn('Contract not initialized, skipping blockchain registration');
      return 'SKIPPED';
    }

    try {
      const tipeMapping: Record<string, number> = {
        'REGULER': 0,
        'PJJ': 1,
        'PRODI_BARU_PTNBH': 2,
        'PRODI_BARU_NON_PTNBH': 3,
      };

      const tx = await this.akreditasiContract.registerAkreditasi(
        data.kodeAkreditasi,
        data.institusiId,
        data.prodiId,
        data.uppsId,
        tipeMapping[data.tipe] || 0,
        data.ipfsHashDokumen || ''
      );

      const receipt: TransactionReceipt = await tx.wait();
      this.logger.log(`Akreditasi registered: ${receipt.hash}`);

      return receipt.hash;
    } catch (error) {
      this.logger.error('Failed to register akreditasi on blockchain:', error);
      return 'FAILED';
    }
  }

  /**
   * Update akreditasi status on blockchain
   */
  async updateAkreditasiStatus(data: {
    kodeAkreditasi: string;
    oldStatus: string;
    newStatus: string;
    ipfsHashBukti?: string;
    keterangan?: string;
  }): Promise<string> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const statusMapping: Record<string, number> = {
      'REGISTRASI': 0,
      'VERIFIKASI_DOKUMEN': 1,
      'PEMBAYARAN': 2,
      'PENAWARAN_ASESOR': 3,
      'ASESMEN_KECUKUPAN': 4,
      'PENGESAHAN_AK': 5,
      'ASESMEN_LAPANGAN': 6,
      'TANGGAPAN_AL': 7,
      'PENGESAHAN_AL': 8,
      'PENETAPAN_PERINGKAT': 9,
      'SINKRONISASI_BANPT': 10,
      'SELESAI': 11,
    };

    const tx = await this.akreditasiContract.updateStatus(
      data.kodeAkreditasi,
      statusMapping[data.newStatus] || 0,
      data.ipfsHashBukti || '',
      data.keterangan || ''
    );

    const receipt: TransactionReceipt = await tx.wait();
    this.logger.log(`Status updated: ${receipt.hash}`);

    return receipt.hash;
  }

  /**
   * Upload dokumen reference to blockchain
   */
  async uploadDokumen(data: {
    kodeAkreditasi: string;
    ipfsHash: string;
    namaDokumen: string;
    tipeDokumen: string;
  }): Promise<string> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const tx = await this.akreditasiContract.uploadDokumen(
      data.kodeAkreditasi,
      data.ipfsHash,
      data.namaDokumen,
      data.tipeDokumen
    );

    const receipt: TransactionReceipt = await tx.wait();
    this.logger.log(`Document uploaded: ${receipt.hash}`);

    return receipt.hash;
  }

  /**
   * Set peringkat akreditasi
   */
  async tetapkanPeringkat(data: {
    kodeAkreditasi: string;
    peringkat: string;
    nilai: number;
    ipfsHashSK: string;
    ipfsHashSertifikat: string;
    tanggalBerakhir: Date;
  }): Promise<string> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const peringkatMapping: Record<string, number> = {
      'BELUM_TERAKREDITASI': 0,
      'BAIK': 1,
      'BAIK_SEKALI': 2,
      'UNGGUL': 3,
    };

    const tanggalBerakhirTimestamp = Math.floor(data.tanggalBerakhir.getTime() / 1000);

    const tx = await this.akreditasiContract.tetapkanPeringkat(
      data.kodeAkreditasi,
      peringkatMapping[data.peringkat] || 0,
      data.nilai,
      data.ipfsHashSK,
      data.ipfsHashSertifikat,
      tanggalBerakhirTimestamp
    );

    const receipt: TransactionReceipt = await tx.wait();
    this.logger.log(`Peringkat set: ${receipt.hash}`);

    return receipt.hash;
  }

  /**
   * Get akreditasi from blockchain
   */
  async getAkreditasi(kodeAkreditasi: string): Promise<any> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const data = await this.akreditasiContract.getAkreditasi(kodeAkreditasi);
    return this.parseAkreditasiData(data);
  }

  /**
   * Get audit logs from blockchain
   */
  async getAuditLogs(kodeAkreditasi: string): Promise<any[]> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const logs = await this.akreditasiContract.getAuditLogs(kodeAkreditasi);
    return logs.map((log: any) => this.parseAuditLog(log));
  }

  /**
   * Get dokumen list from blockchain
   */
  async getDokumen(kodeAkreditasi: string): Promise<any[]> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const docs = await this.akreditasiContract.getDokumen(kodeAkreditasi);
    return docs.map((doc: any) => ({
      ipfsHash: doc.ipfsHash,
      namaDokumen: doc.namaDokumen,
      tipeDokumen: doc.tipeDokumen,
      uploadedAt: new Date(Number(doc.uploadedAt) * 1000),
      uploadedBy: doc.uploadedBy,
      isVerified: doc.isVerified,
    }));
  }

  /**
   * Register tenant
   */
  async registerTenant(institusiId: number, nama: string): Promise<string> {
    if (!this.akreditasiContract) {
      throw new Error('Contract not initialized');
    }

    const tx = await this.akreditasiContract.registerTenant(institusiId, nama);
    const receipt: TransactionReceipt = await tx.wait();

    return receipt.hash;
  }

  /**
   * Get total akreditasi count
   */
  async getTotalAkreditasi(): Promise<number> {
    if (!this.akreditasiContract) {
      return 0;
    }

    const total = await this.akreditasiContract.getTotalAkreditasi();
    return Number(total);
  }

  /**
   * Parse akreditasi data from blockchain
   */
  private parseAkreditasiData(data: any): any {
    const statusNames = [
      'REGISTRASI', 'VERIFIKASI_DOKUMEN', 'PEMBAYARAN', 'PENAWARAN_ASESOR',
      'ASESMEN_KECUKUPAN', 'PENGESAHAN_AK', 'ASESMEN_LAPANGAN', 'TANGGAPAN_AL',
      'PENGESAHAN_AL', 'PENETAPAN_PERINGKAT', 'SINKRONISASI_BANPT', 'SELESAI'
    ];

    const peringkatNames = ['BELUM_TERAKREDITASI', 'BAIK', 'BAIK_SEKALI', 'UNGGUL'];
    const tipeNames = ['REGULER', 'PJJ', 'PRODI_BARU_PTNBH', 'PRODI_BARU_NON_PTNBH'];

    return {
      kodeAkreditasi: data.kodeAkreditasi,
      institusiId: Number(data.institusiId),
      prodiId: Number(data.prodiId),
      uppsId: Number(data.uppsId),
      tipe: tipeNames[Number(data.tipe)] || 'REGULER',
      status: statusNames[Number(data.status)] || 'REGISTRASI',
      peringkat: peringkatNames[Number(data.peringkat)] || 'BELUM_TERAKREDITASI',
      nilaiAkreditasi: Number(data.nilaiAkreditasi),
      ipfsHashDokumen: data.ipfsHashDokumen,
      ipfsHashSK: data.ipfsHashSK,
      ipfsHashSertifikat: data.ipfsHashSertifikat,
      tanggalRegistrasi: new Date(Number(data.tanggalRegistrasi) * 1000),
      tanggalTerakreditasi: data.tanggalTerakreditasi > 0 
        ? new Date(Number(data.tanggalTerakreditasi) * 1000) 
        : null,
      tanggalBerakhir: data.tanggalBerakhir > 0 
        ? new Date(Number(data.tanggalBerakhir) * 1000) 
        : null,
      registeredBy: data.registeredBy,
      isActive: data.isActive,
    };
  }

  /**
   * Parse audit log from blockchain
   */
  private parseAuditLog(log: any): any {
    const statusNames = [
      'REGISTRASI', 'VERIFIKASI_DOKUMEN', 'PEMBAYARAN', 'PENAWARAN_ASESOR',
      'ASESMEN_KECUKUPAN', 'PENGESAHAN_AK', 'ASESMEN_LAPANGAN', 'TANGGAPAN_AL',
      'PENGESAHAN_AL', 'PENETAPAN_PERINGKAT', 'SINKRONISASI_BANPT', 'SELESAI'
    ];

    return {
      kodeAkreditasi: log.kodeAkreditasi,
      fromStatus: statusNames[Number(log.fromStatus)] || 'UNKNOWN',
      toStatus: statusNames[Number(log.toStatus)] || 'UNKNOWN',
      ipfsHashBukti: log.ipfsHashBukti,
      keterangan: log.keterangan,
      changedBy: log.changedBy,
      timestamp: new Date(Number(log.timestamp) * 1000),
    };
  }
}
