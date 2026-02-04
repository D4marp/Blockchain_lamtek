export interface Akreditasi {
  id: string;
  nomorPengajuan: string;
  namaProdi: string;
  namaUniversitas: string;
  jenjang: string;
  tipeAkreditasi: 'REGULER' | 'PJJ' | 'PRODI_BARU_PTNBH' | 'PRODI_BARU_NON_PTNBH';
  status: AkreditasiStatus;
  peringkat?: PeringkatAkreditasi;
  tanggalPengajuan: string;
  tanggalKedaluwarsa?: string;
  progress: number;
  tenantId: string;
  createdAt: string;
  updatedAt: string;
}

export type AkreditasiStatus =
  | 'PENGAJUAN'
  | 'VERIFIKASI_DOKUMEN'
  | 'ASESMEN_KECUKUPAN'
  | 'ASESMEN_LAPANGAN'
  | 'VALIDASI'
  | 'PENETAPAN'
  | 'SELESAI'
  | 'DITOLAK'
  | 'BANDING';

export type PeringkatAkreditasi =
  | 'UNGGUL'
  | 'BAIK_SEKALI'
  | 'BAIK'
  | 'TIDAK_TERAKREDITASI';

export interface AsesmenKecukupan {
  id: string;
  akreditasiId: string;
  asesor1Id?: string;
  asesor2Id?: string;
  status: 'MENUNGGU' | 'PROSES' | 'SELESAI';
  nilaiAsesor1?: number;
  nilaiAsesor2?: number;
  nilaiAkhir?: number;
  rekomendasi?: string;
  catatanAsesor1?: string;
  catatanAsesor2?: string;
  tanggalMulai?: string;
  tanggalSelesai?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AsesmenLapangan {
  id: string;
  akreditasiId: string;
  timAsesorIds: string[];
  status: 'MENUNGGU' | 'TERJADWAL' | 'BERLANGSUNG' | 'SELESAI';
  tanggalMulai?: string;
  tanggalSelesai?: string;
  lokasi?: string;
  nilaiAkhir?: number;
  peringkatRekomendasi?: PeringkatAkreditasi;
  laporanIpfsHash?: string;
  createdAt: string;
  updatedAt: string;
}

export interface Dokumen {
  id: string;
  akreditasiId: string;
  nama: string;
  kategori: string;
  ipfsHash: string;
  ukuran: number;
  mimeType: string;
  isVerified: boolean;
  blockchainTxHash?: string;
  uploadedBy: string;
  createdAt: string;
}

export interface Tenant {
  id: string;
  nama: string;
  kode: string;
  alamat?: string;
  email?: string;
  telepon?: string;
  logo?: string;
  isActive: boolean;
  createdAt: string;
}

export type RoleUser = 
  | 'ADMIN'
  | 'SEKRETARIAT'
  | 'KOMITE_EVALUASI'
  | 'MAJELIS_AKREDITASI'
  | 'ASESOR'
  | 'PRODI'
  | 'UPPS'
  | 'VALIDATOR';

export interface User {
  id: number;
  name: string;
  email: string;
  role: RoleUser;
  tenantId?: number;
  institusiId?: number;
  noIdentitas?: string;
  noSertifikatEdukatif?: string;
  isActive: boolean;
  lastLogin?: string;
  avatar?: string;
  createdAt: string;
  updatedAt?: string;
}

export type StatusPembayaran = 'PENDING' | 'PAID' | 'VERIFIED' | 'REJECTED' | 'CANCELLED';
export type MetodePembayaran = 'TRANSFER' | 'VIRTUAL_ACCOUNT' | 'QRIS' | 'CREDIT_CARD';

export interface Pembayaran {
  id: number;
  akreditasiId: number;
  skemaPembayaranId?: number;
  jumlah: number;
  jumlahBayar?: number;
  tanggalJatuhTempo?: string;
  tanggalBayar?: string;
  buktiBayarUrl?: string;
  status: StatusPembayaran;
  metodePembayaran?: MetodePembayaran;
  nomorVa?: string;
  catatan?: string;
  verifikasiOleh?: number;
  createdAt?: string;
  updatedAt?: string;
}

export type StatusRegistrasi = 'DRAFT' | 'SUBMITTED' | 'VERIFIED' | 'APPROVED' | 'REJECTED' | 'CANCELLED';

export interface RegistrasiAkreditasi {
  id: number;
  prodiId: number;
  institusiId: number;
  uppsId?: number;
  jenjangId?: number;
  tipeAkreditasi?: string;
  status: StatusRegistrasi;
  tanggalPengajuan?: string;
  tanggalVerifikasi?: string;
  tanggalApproval?: string;
  catatan?: string;
  createdAt?: string;
  updatedAt?: string;
}

export interface BlockchainTransaction {
  txHash: string;
  blockNumber: number;
  timestamp: string;
  action: string;
  actor: string;
  data: Record<string, any>;
}

export interface DashboardStats {
  totalAkreditasi: number;
  akreditasiAktif: number;
  selesaiBulanIni: number;
  menungguAsesmen: number;
  persentaseUnggul: number;
  totalDokumen: number;
}

export interface ChartData {
  name: string;
  value: number;
}

export interface TimelineItem {
  id: string;
  status: AkreditasiStatus;
  tanggal: string;
  catatan?: string;
  actor?: string;
  txHash?: string;
}
